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

# =====================================================================================
# MODULE-ORIENTATION OPTION: VERTICAL BIFACIAL, EAST–WEST FACING (rows run north–south)
# Appended after all baseline (tilted) draws, so baseline results are unchanged.
# =====================================================================================
TILT, VERT = "tilted", "vertical bifacial"
# --- energy, both orientations ---
y_tilt_w = tri(1550, 1650, 1750)          # MWh/MW_dc·yr, low-tilt over water (Little Dell / F1)
y_tilt_p = tri(1750, 1850, 1950)          # MWh/MW_dc·yr, fixed tilt on playa
# Vertical/tilted yield ratio: low albedo over water (≈0.05–0.08) penalises vertical; winter
# snow/ice albedo and no snow cover on the face partly compensate. On salt-crust playa
# (albedo ≈0.3–0.5) vertical can match or beat tilted (simulation: up to +15% at 0.5;
# desert field data: clean tilted ≈4% ahead) and soils less.
r_vert_w = tri(0.78, 0.90, 1.02)
r_vert_p = tri(0.92, 1.03, 1.15)
dens_v_w = tri(0.15, 0.20, 0.26)          # MW_dc/acre: vertical rows need wide spacing (tilted 0.40)
dens_v_p = tri(0.11, 0.15, 0.20)          # MW_dc/acre on playa (tilted 0.25; Next2Sun agri ≈0.12–0.14)
# --- vertical over-water ecology ---
s_v    = beta_ms(0.20, 0.08)              # evaporation suppression: thin shade strips, little canopy
halo_v = tri(0.00, 0.05, 0.30)            # rows can act as wind fences when wind crosses them
par_v  = beta_ms(0.25, 0.08)              # light reduction under a vertical array
do_v   = tri(0.0, 0.1, 0.5)               # mg/L
piles_v= tri(4, 10, 40)                   # piles per acre (posts along north–south rows)
fll_v  = rng.uniform(0.3, 0.9, N)

S = "Little Dell"
for scen, A in [("Zone A (5%)", 12.45), ("Full build-out (25%)", 62.45)]:
    cov = A/A_res
    add(S,"Capacity",f"{scen} — {TILT}","MW_dc",np.full(N, 0.40*A),"A","0.40 MW_dc/acre")
    add(S,"Annual energy",f"{scen} — {TILT}","MWh/yr",0.40*A*y_tilt_w,"C")
    add(S,"Capacity",f"{scen} — {VERT}","MW_dc",dens_v_w*A,"C","wider row spacing")
    add(S,"Annual energy",f"{scen} — {VERT}","MWh/yr",dens_v_w*A*y_tilt_w*r_vert_w,"C","morning/evening peaks")
    sv = A*E_ld*s_v*(1+halo_v)
    add(S,"Evaporation saved",f"{scen} — {VERT}","acre-ft/yr",sv,"C")
    add(S,"Evaporation saved, share of SLCDPU annual delivery",f"{scen} — {VERT}","%",100*sv/rng.uniform(80_000, 97_000, N),"C")
    add(S,"Light (PAR) reduction under array",f"{scen} — {VERT}","%",100*par_v,"C")
    add(S,"Reservoir-wide primary production change",f"{scen} — {VERT}","%",-100*cov*par_v*fll_v,"C")
    add(S,"Dissolved-oxygen deficit under array",f"{scen} — {VERT}","mg/L",do_v,"C")
    add(S,"Piles required",f"{scen} — {VERT}","piles",A*piles_v,"C","span-dependent")
    e_t = 0.40*A*y_tilt_w; e_v = dens_v_w*A*y_tilt_w*r_vert_w
    add(S,"Area for energy equal to tilted",f"{scen} — {VERT}","acres",A*e_t/e_v,"C")

S = "Great Salt Lake"
add(S,"Annual energy",f"F1 (5 ac) — {TILT}","MWh/yr",2.0*y_tilt_w,"C")
add(S,"Annual energy",f"F1 (5 ac) — {VERT}","MWh/yr",dens_v_w*5.0*y_tilt_w*r_vert_w,"C")
add(S,"F1 evaporation saved",f"F1 (5 ac) — {VERT}","acre-ft/yr",5.0*E_gsl*s_v*(1+halo_v),"C")
add(S,"F1 piles required",f"F1 (5 ac) — {VERT}","piles",5.0*piles_v,"C","span-dependent")
shade_v = rng.uniform(0.10, 0.25, N)      # fraction of playa shaded by vertical rows (tilted GCR 0.35–0.50)
f_dust_v = rng.uniform(0.30, 0.85, N)     # rows act as sand fences across the SW wind
M_vert   = lnorm_q(0.8, 1.6)              # fatality-rate multiplier vs tilted: less water-like area seen
                                          # from above, but vertical faces add collision risk — sign uncertain
for scen, A in [("P1 (400 ac)", 400.0), ("Full build-out (1,600 ac)", 1600.0)]:
    add(S,"Capacity",f"{scen} — {TILT}","MW_dc",np.full(N, 0.25*A),"A","0.25 MW_dc/acre")
    add(S,"Annual energy",f"{scen} — {TILT}","MWh/yr",0.25*A*y_tilt_p,"C")
    mw_v = dens_v_p*A
    add(S,"Capacity",f"{scen} — {VERT}","MW_dc",mw_v,"C","wider row spacing")
    add(S,"Annual energy",f"{scen} — {VERT}","MWh/yr",mw_v*y_tilt_p*r_vert_p,"C","high-albedo salt crust favours bifacial")
    add(S,"Playa soil-water evaporation avoided",f"{scen} — {VERT}","acre-ft/yr",A*shade_v*e_pl*g_red,"C")
    fat_v = mw_v*R_base*M_gsl*M_vert
    add(S,"Avian fatalities",f"{scen} — {VERT}","birds/yr",fat_v,"C","orientation effect on birds unmeasured")
    fat_t = 0.25*A*R_base*M_gsl
    add(S,"Avian fatalities per GWh",f"{scen} — {TILT}","birds/GWh",fat_t/(0.25*A*y_tilt_p/1000),"C")
    add(S,"Avian fatalities per GWh",f"{scen} — {VERT}","birds/GWh",fat_v/(mw_v*y_tilt_p*r_vert_p/1000),"C")
    add(S,"Area for energy equal to tilted",f"{scen} — {VERT}","acres",A*(0.25*y_tilt_p)/(dens_v_p*y_tilt_p*r_vert_p),"C")
add(S,"PM10 emission avoided within array footprint",f"operations — {VERT}","% of footprint emission",100*f_dust_v,"C","rows act as sand fences")

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
