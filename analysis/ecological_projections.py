"""Monte Carlo ecological projections — numpy port of analysis/ecological_projections.R.
Design basis: ELEVATED, PILE-MOUNTED over-water PV (modules on racks several feet above the
water, carried on piles fixed in the bed). Nothing rests on the water surface.
Same parameterisation and N as the R script; RNG streams differ, so results agree within
Monte Carlo error."""
import numpy as np, csv, sys
N = 100_000
rng = np.random.default_rng(20261105)
tri = lambda lo, mode, hi: rng.triangular(lo, mode, hi, N)
def beta_ms(mean, sd):
    k = mean*(1-mean)/sd**2 - 1
    return rng.beta(mean*k, (1-mean)*k, N)
def lnorm_q(median, hi97):           # lognormal from median and 97.5th percentile
    s = np.log(hi97/median)/1.959964
    return rng.lognormal(np.log(median), s, N)

rows = []
def add(site, qty, scen, unit, x, grade, note=""):
    lo, med, hi = np.percentile(x, [2.5, 50, 97.5])
    rows.append(dict(site=site, quantity=qty, scenario=scen, unit=unit,
                     median=med, lo95=lo, hi95=hi, grade=grade, note=note))

# ---------------- shared parameters: elevated, open-sided canopy ----------------
# Evaporation suppression beneath an elevated canopy. No lake measurement exists for elevated
# arrays. Analogues: floating PV (44% measured, full-scale), canal-top PV (44–90% assumed for
# fully covered narrow canals). An open-sided canopy blocks radiation but lets wind pass beneath,
# so suppression is set below both analogues.
s_under  = beta_ms(0.40, 0.12)
halo     = tri(0.00, 0.05, 0.25)   # downwind sheltering bonus — small, air moves under the canopy
par_red  = beta_ms(0.60, 0.10)     # light reduction under the canopy (diffuse + side light reach the water)
piles_ac = tri(5, 15, 60)          # piles per acre (large-span trusses ≈8/acre at HG14; short-span pond PV higher)
pile_d   = rng.uniform(0.5, 1.2, N)  # pile diameter, m

# =============== LITTLE DELL ===============
S = "Little Dell"
A_res = 249.0
E_ld  = tri(2.0, 2.6, 3.3)         # gross lake evaporation, ft/yr (high elevation, winter ice)
for scen, A in [("Zone A (5%)", 12.45), ("Full build-out (25%)", 62.45)]:
    cov = A/A_res
    saved = A*E_ld*s_under*(1+halo)
    add(S,"Evaporation saved",scen,"acre-ft/yr",saved,"C","elevated-canopy suppression unmeasured")
    add(S,"Evaporation saved, share of reservoir evaporation",scen,"%",100*saved/(A_res*E_ld),"C")
    add(S,"Evaporation saved, share of storage capacity",scen,"%",100*saved/20500,"C")
    delivery = rng.uniform(80_000, 97_000, N)          # SLCDPU delivered ~81,600 af (2022), ~97,000 af (2020)
    add(S,"Evaporation saved, share of SLCDPU annual delivery",scen,"%",100*saved/delivery,"C")
    dT_under = tri(-1.5, -0.4, 0.2)                     # shading cools; open sides keep air exchange
    mixw = rng.uniform(0.5, 1.0, N)
    add(S,"Surface water temp change under array (summer day)",scen,"°C",dT_under,"C")
    add(S,"Reservoir-mean surface temp change (summer)",scen,"°C",dT_under*cov*mixw,"C")
    add(S,"Light (PAR) reduction under array",scen,"%",100*par_red,"C")
    chl_under = np.clip(rng.normal(-0.20, 0.25, N), -0.85, 0.5)
    add(S,"Chlorophyll-a change under array",scen,"%",100*chl_under,"C","sign uncertain; trophic-state dependent")
    add(S,"Reservoir-wide chlorophyll-a change",scen,"%",100*chl_under*cov,"C")
    fll = rng.uniform(0.3, 0.9, N)
    add(S,"Reservoir-wide primary production change",scen,"%",-100*cov*par_red*fll,"C")
    do_def = tri(0.0, 0.3, 1.0)                         # surface stays open to air: smaller than floating (1.1–1.7)
    add(S,"Dissolved-oxygen deficit under array",scen,"mg/L",do_def,"C","surface stays open to air and wind")
    add(S,"Reservoir-mean DO deficit",scen,"mg/L",do_def*cov*mixw,"C")
    g_t = rng.uniform(0, 0.5, N); g_o = rng.uniform(0, 0.5, N)
    add(S,"Net summer cold-water (trout) habitat change",scen,"% of reservoir",100*cov*(g_t-g_o),"C","structural prior; sign unknown")
    emerg = rng.uniform(-0.2, 0.6, N)
    add(S,"Aquatic-insect emergence change, reservoir-wide",scen,"%",-100*cov*emerg,"C","prior-driven")
    add(S,"Water surface beneath canopy (remains open)",scen,"acres",np.full(N, A),"A","deterministic")
    n_p = A*piles_ac
    add(S,"Piles required",scen,"piles",n_p,"C","span-dependent")
    add(S,"Reservoir bed occupied by piles",scen,"m²",n_p*np.pi*(pile_d/2)**2,"C")

# =============== GREAT SALT LAKE ===============
S = "Great Salt Lake"
E_fresh  = tri(3.0, 3.33, 4.17)    # ft/yr freshwater-equivalent (36–50 in; ~40 in central)
sal_fac  = rng.uniform(0.65, 0.85, N)   # near-saturated brine evaporates ~70% of fresh
E_gsl    = E_fresh*sal_fac
lake_ac  = rng.uniform(550_000, 700_000, N)
tot_evap = rng.uniform(2.0e6, 3.0e6, N)

saved_f1 = 5.0*E_gsl*s_under*(1+halo)
add(S,"F1 evaporation saved","F1 (5 ac)","acre-ft/yr",saved_f1,"C","elevated-canopy suppression unmeasured")
add(S,"F1 saving, share of lake evaporation","F1 (5 ac)","%",100*saved_f1/tot_evap,"C")
add(S,"F1 equivalent lake-level change","F1 (5 ac)","inches/yr",12*saved_f1/lake_ac,"C")
need = 60_000/(E_gsl*s_under*(1+halo))       # 1 ft over 10 yr ≈ 60,000 af/yr
add(S,"Over-water PV area needed to offset 1 ft of decline per decade","hypothetical","acres",need,"C")
add(S,"  … as share of current lake surface","hypothetical","%",100*need/lake_ac,"C")
add(S,"F1 lake-scale primary-production change","F1 (5 ac)","%",-100*(5.0/lake_ac)*par_red,"C")
n_f1 = 5.0*piles_ac
add(S,"F1 piles required","F1 (5 ac)","piles",n_f1,"C","span-dependent")

gcr   = rng.uniform(0.35, 0.50, N)
e_pl  = tri(0.1, 0.3, 1.0)
g_red = rng.uniform(0.1, 0.5, N)
for scen, A in [("P1 (400 ac)",400.0),("Full build-out (1,600 ac)",1600.0)]:
    add(S,"Playa soil-water evaporation avoided",scen,"acre-ft/yr",A*gcr*e_pl*g_red,"C","fate of saved groundwater uncertain")

R_base = lnorm_q(1.5, 3.5)
M_gsl  = lnorm_q(1.5, 6.0)
w_share= beta_ms(0.35, 0.12)
for scen, MW in [("P1 (100 MW)",100.0),("Full build-out (402 MW)",402.0)]:
    fat = MW*R_base*M_gsl
    add(S,"Avian fatalities",scen,"birds/yr",fat,"C","desert rates × assumed GSL multiplier")
    add(S,"  … of which water-associated species",scen,"birds/yr",fat*w_share,"C")
    add(S,"  … as share of ~12 M annual lake users",scen,"%",100*fat/12e6,"C")
f_dust = rng.uniform(0.2, 0.8, N)
add(S,"PM10 emission avoided within array footprint","operations","% of footprint emission",100*f_dust,"C","corridor emissivity unmeasured")

with open(sys.argv[1], "w", newline="") as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0])); w.writeheader()
    for r in rows: w.writerow({k:(f"{v:.6g}" if isinstance(v,float) else v) for k,v in r.items()})
for r in rows:
    print(f"{r['site'][:6]:6} | {r['scenario'][:22]:22} | {r['quantity'][:56]:56} | {r['median']:>10.4g} [{r['lo95']:.4g}, {r['hi95']:.4g}] {r['unit']} ({r['grade']})")

# sensitivity (Spearman via ranks)
rk = lambda x: np.argsort(np.argsort(x)).astype(float)
sp = lambda a, b: np.corrcoef(rk(a), rk(b))[0, 1]
ld_full = 62.45*E_ld*s_under*(1+halo)
print("\nrho LD full evap: suppression %.2f, evap_depth %.2f, halo %.2f" % (sp(s_under, ld_full), sp(E_ld, ld_full), sp(halo, ld_full)))
print("rho GSL area: suppression %.2f, halo %.2f, salinity %.2f, fresh_evap %.2f" % (sp(s_under, need), sp(halo, need), sp(sal_fac, need), sp(E_fresh, need)))
fat = 402*R_base*M_gsl
print("rho GSL fatalities: multiplier %.2f, base %.2f" % (sp(M_gsl, fat), sp(R_base, fat)))
