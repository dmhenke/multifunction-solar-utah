## =============================================================================
## Monte Carlo ecological projections — Little Dell Reservoir & Great Salt Lake
## Design basis: ELEVATED, PILE-MOUNTED over-water PV — modules on racks several feet above the
## water, carried on piles fixed in the bed. Nothing rests on the water surface.
## Base R only. Reproduces analysis/ecological_projections_results.csv within
## Monte Carlo error (the numpy port in this folder uses a different RNG stream).
##
## Intervals are 95% UNCERTAINTY intervals: the 2.5th and 97.5th percentiles of
## outputs when every uncertain input is sampled from its stated distribution.
## They are not sampling-based confidence intervals — no site data exist yet.
##
## Evidence grades:
##   A  deterministic (geometry)
##   B  parameters taken from field measurements or validated models
##   C  analogue transfer or structural prior — the interval reflects assumptions
## =============================================================================

set.seed(20261105)
N <- 1e5

## ---- helpers ----------------------------------------------------------------
rtri <- function(n, lo, mode, hi) {            # triangular via inverse CDF
  u <- runif(n); fc <- (mode - lo) / (hi - lo)
  ifelse(u < fc,
         lo + sqrt(u * (hi - lo) * (mode - lo)),
         hi - sqrt((1 - u) * (hi - lo) * (hi - mode)))
}
rbeta_ms <- function(n, mean, sd) {             # beta from mean and SD
  k <- mean * (1 - mean) / sd^2 - 1
  rbeta(n, mean * k, (1 - mean) * k)
}
rlnorm_q <- function(n, median, hi975) {        # lognormal from median and 97.5th pct
  rlnorm(n, log(median), log(hi975 / median) / qnorm(0.975))
}

results <- list()
add <- function(site, quantity, scenario, unit, x, grade, note = "") {
  q <- quantile(x, c(0.025, 0.5, 0.975), names = FALSE)
  results[[length(results) + 1]] <<- data.frame(
    site = site, quantity = quantity, scenario = scenario, unit = unit,
    median = signif(q[2], 4), lo95 = signif(q[1], 4), hi95 = signif(q[3], 4),
    grade = grade, note = note, stringsAsFactors = FALSE)
}

## ---- shared parameters --------------------------------------------------------
## Evaporation suppression beneath an ELEVATED canopy. No lake measurement exists for
## elevated arrays. Analogues: floating PV (44% measured, full scale, EGU26-11025) and
## canal-top PV (44–90% assumed for fully covered narrow canals, McKuin et al. 2021).
## An open-sided canopy blocks radiation but lets wind pass beneath, so it is set lower.
s_under <- rbeta_ms(N, 0.40, 0.12)
## Downwind sheltering bonus — small, because air moves freely under the canopy.
halo    <- rtri(N, 0.00, 0.05, 0.25)
## Light reduction under the canopy: diffuse and side light still reach the water.
par_red <- rbeta_ms(N, 0.60, 0.10)
## Piles per acre (large-span trusses ≈8/acre at the HG14 offshore array; short spans higher)
piles_ac <- rtri(N, 5, 15, 60)
pile_d   <- runif(N, 0.5, 1.2)                  # pile diameter, m

## ============================== LITTLE DELL ===================================
S     <- "Little Dell"
A_res <- 249
E_ld  <- rtri(N, 2.0, 2.6, 3.3)                # gross evaporation, ft/yr (≈5,790 ft elev.)

for (sc in list(list("Zone A (5%)", 12.45), list("Full build-out (25%)", 62.45))) {
  scen <- sc[[1]]; A <- sc[[2]]; cov <- A / A_res
  saved <- A * E_ld * s_under * (1 + halo)
  add(S, "Evaporation saved", scen, "acre-ft/yr", saved, "C", "elevated-canopy suppression unmeasured")
  add(S, "Evaporation saved, share of reservoir evaporation", scen, "%",
      100 * saved / (A_res * E_ld), "C")
  add(S, "Evaporation saved, share of storage capacity", scen, "%",
      100 * saved / 20500, "C")
  delivery <- runif(N, 80000, 97000)           # SLCDPU delivered ~81,600 af (2022), ~97,000 af (2020)
  add(S, "Evaporation saved, share of SLCDPU annual delivery", scen, "%",
      100 * saved / delivery, "C")

  dT_under <- rtri(N, -1.5, -0.4, 0.2)          # °C; shading cools, open sides keep air exchange
  mixw     <- runif(N, 0.5, 1.0)
  add(S, "Surface water temp change under array (summer day)", scen, "°C", dT_under, "C")
  add(S, "Reservoir-mean surface temp change (summer)", scen, "°C", dT_under * cov * mixw, "C")
  add(S, "Light (PAR) reduction under array", scen, "%", 100 * par_red, "C")

  chl_under <- pmin(pmax(rnorm(N, -0.20, 0.25), -0.85), 0.50)   # field (floating): −80% to increases
  add(S, "Chlorophyll-a change under array", scen, "%", 100 * chl_under, "C",
      "sign uncertain; trophic-state dependent")
  add(S, "Reservoir-wide chlorophyll-a change", scen, "%", 100 * chl_under * cov, "C")
  fll <- runif(N, 0.3, 0.9)                     # light-limited share of production
  add(S, "Reservoir-wide primary production change", scen, "%", -100 * cov * par_red * fll, "C")

  do_def <- rtri(N, 0.0, 0.3, 1.0)              # mg/L; surface open to air (floating: 1.1–1.7 lower)
  add(S, "Dissolved-oxygen deficit under array", scen, "mg/L", do_def, "C",
      "surface stays open to air and wind")
  add(S, "Reservoir-mean DO deficit", scen, "mg/L", do_def * cov * mixw, "C")

  g_t <- runif(N, 0, 0.5); g_o <- runif(N, 0, 0.5)
  add(S, "Net summer cold-water (trout) habitat change", scen, "% of reservoir",
      100 * cov * (g_t - g_o), "C", "structural prior; sign unknown")
  emerg <- runif(N, -0.2, 0.6)
  add(S, "Aquatic-insect emergence change, reservoir-wide", scen, "%", -100 * cov * emerg, "C",
      "prior-driven")
  add(S, "Water surface beneath canopy (remains open)", scen, "acres", rep(A, N), "A", "deterministic")
  n_p <- A * piles_ac
  add(S, "Piles required", scen, "piles", n_p, "C", "span-dependent")
  add(S, "Reservoir bed occupied by piles", scen, "m²", n_p * pi * (pile_d / 2)^2, "C")
}

## ============================ GREAT SALT LAKE =================================
S        <- "Great Salt Lake"
E_fresh  <- rtri(N, 3.0, 3.33, 4.17)            # ft/yr freshwater-equivalent (36–50 in)
sal_fac  <- runif(N, 0.65, 0.85)                # brine evaporates ~70% of fresh
E_gsl    <- E_fresh * sal_fac
lake_ac  <- runif(N, 5.5e5, 7.0e5)              # surface area near 4,191.6 ft
tot_evap <- runif(N, 2.0e6, 3.0e6)              # af/yr total evaporation

saved_f1 <- 5 * E_gsl * s_under * (1 + halo)
add(S, "F1 evaporation saved", "F1 (5 ac)", "acre-ft/yr", saved_f1, "C", "elevated-canopy suppression unmeasured")
add(S, "F1 saving, share of lake evaporation", "F1 (5 ac)", "%", 100 * saved_f1 / tot_evap, "C")
add(S, "F1 equivalent lake-level change", "F1 (5 ac)", "inches/yr", 12 * saved_f1 / lake_ac, "C")
need <- 6e4 / (E_gsl * s_under * (1 + halo))    # 1 ft over 10 yr ≈ 60,000 af/yr
add(S, "Over-water PV area needed to offset 1 ft of decline per decade", "hypothetical", "acres", need, "C")
add(S, "  … as share of current lake surface", "hypothetical", "%", 100 * need / lake_ac, "C")
add(S, "F1 lake-scale primary-production change", "F1 (5 ac)", "%",
    -100 * (5 / lake_ac) * par_red, "C")
add(S, "F1 piles required", "F1 (5 ac)", "piles", 5 * piles_ac, "C", "span-dependent")

gcr   <- runif(N, 0.35, 0.50)                   # ground-coverage ratio
e_pl  <- rtri(N, 0.1, 0.3, 1.0)                 # playa evaporation from shallow groundwater, ft/yr
g_red <- runif(N, 0.1, 0.5)
for (sc in list(list("P1 (400 ac)", 400), list("Full build-out (1,600 ac)", 1600))) {
  add(S, "Playa soil-water evaporation avoided", sc[[1]], "acre-ft/yr",
      sc[[2]] * gcr * e_pl * g_red, "C", "fate of saved groundwater uncertain")
}

R_base  <- rlnorm_q(N, 1.5, 3.5)                # desert PV fatalities/MW/yr (Kosciuch 2020)
M_gsl   <- rlnorm_q(N, 1.5, 6.0)                # waterbird-concentration multiplier (no data)
w_share <- rbeta_ms(N, 0.35, 0.12)              # water-associated share (<13% in desert)
for (sc in list(list("P1 (100 MW)", 100), list("Full build-out (402 MW)", 402))) {
  fat <- sc[[2]] * R_base * M_gsl
  add(S, "Avian fatalities", sc[[1]], "birds/yr", fat, "C", "desert rates × assumed GSL multiplier")
  add(S, "  … of which water-associated species", sc[[1]], "birds/yr", fat * w_share, "C")
  add(S, "  … as share of ~12 M annual lake users", sc[[1]], "%", 100 * fat / 12e6, "C")
}
add(S, "PM10 emission avoided within array footprint", "operations", "% of footprint emission",
    100 * runif(N, 0.2, 0.8), "C", "corridor emissivity unmeasured")

## =============================================================================
## MODULE-ORIENTATION OPTION: VERTICAL BIFACIAL, EAST–WEST FACING (rows run N–S)
## Appended after all baseline (tilted) draws, so baseline results are unchanged.
## =============================================================================
TILT <- "tilted"; VERT <- "vertical bifacial"
y_tilt_w <- rtri(N, 1550, 1650, 1750)            # MWh/MW_dc/yr, low tilt over water
y_tilt_p <- rtri(N, 1750, 1850, 1950)            # MWh/MW_dc/yr, fixed tilt on playa
## Vertical/tilted yield ratio: low water albedo penalises vertical; snow/ice albedo and a
## snow-free face partly compensate. High-albedo salt crust (0.3–0.5) favours vertical.
r_vert_w <- rtri(N, 0.78, 0.90, 1.02)
r_vert_p <- rtri(N, 0.92, 1.03, 1.15)
dens_v_w <- rtri(N, 0.15, 0.20, 0.26)            # MW_dc/acre over water (tilted 0.40)
dens_v_p <- rtri(N, 0.11, 0.15, 0.20)            # MW_dc/acre on playa (tilted 0.25)
s_v      <- rbeta_ms(N, 0.20, 0.08)              # evaporation suppression, vertical rows
halo_v   <- rtri(N, 0.00, 0.05, 0.30)            # rows act as wind fences when wind crosses them
par_v    <- rbeta_ms(N, 0.25, 0.08)              # light reduction under a vertical array
do_v     <- rtri(N, 0.0, 0.1, 0.5)               # mg/L
piles_v  <- rtri(N, 4, 10, 40)                   # piles per acre
fll_v    <- runif(N, 0.3, 0.9)

S <- "Little Dell"
for (sc in list(list("Zone A (5%)", 12.45), list("Full build-out (25%)", 62.45))) {
  scen <- sc[[1]]; A <- sc[[2]]; cov <- A / A_res
  add(S, "Capacity", paste(scen, "—", TILT), "MW_dc", rep(0.40 * A, N), "A", "0.40 MW_dc/acre")
  add(S, "Annual energy", paste(scen, "—", TILT), "MWh/yr", 0.40 * A * y_tilt_w, "C")
  add(S, "Capacity", paste(scen, "—", VERT), "MW_dc", dens_v_w * A, "C", "wider row spacing")
  add(S, "Annual energy", paste(scen, "—", VERT), "MWh/yr", dens_v_w * A * y_tilt_w * r_vert_w, "C", "morning/evening peaks")
  sv <- A * E_ld * s_v * (1 + halo_v)
  add(S, "Evaporation saved", paste(scen, "—", VERT), "acre-ft/yr", sv, "C")
  add(S, "Evaporation saved, share of SLCDPU annual delivery", paste(scen, "—", VERT), "%",
      100 * sv / runif(N, 80000, 97000), "C")
  add(S, "Light (PAR) reduction under array", paste(scen, "—", VERT), "%", 100 * par_v, "C")
  add(S, "Reservoir-wide primary production change", paste(scen, "—", VERT), "%", -100 * cov * par_v * fll_v, "C")
  add(S, "Dissolved-oxygen deficit under array", paste(scen, "—", VERT), "mg/L", do_v, "C")
  add(S, "Piles required", paste(scen, "—", VERT), "piles", A * piles_v, "C", "span-dependent")
  e_t <- 0.40 * A * y_tilt_w; e_v <- dens_v_w * A * y_tilt_w * r_vert_w
  add(S, "Area for energy equal to tilted", paste(scen, "—", VERT), "acres", A * e_t / e_v, "C")
}

S <- "Great Salt Lake"
add(S, "Annual energy", paste("F1 (5 ac) —", TILT), "MWh/yr", 2 * y_tilt_w, "C")
add(S, "Annual energy", paste("F1 (5 ac) —", VERT), "MWh/yr", dens_v_w * 5 * y_tilt_w * r_vert_w, "C")
add(S, "F1 evaporation saved", paste("F1 (5 ac) —", VERT), "acre-ft/yr", 5 * E_gsl * s_v * (1 + halo_v), "C")
add(S, "F1 piles required", paste("F1 (5 ac) —", VERT), "piles", 5 * piles_v, "C", "span-dependent")
shade_v  <- runif(N, 0.10, 0.25)                 # playa fraction shaded by vertical rows
f_dust_v <- runif(N, 0.30, 0.85)                 # rows act as sand fences across the SW wind
M_vert   <- rlnorm_q(N, 0.8, 1.6)                # fatality multiplier vs tilted — sign uncertain
for (sc in list(list("P1 (400 ac)", 400), list("Full build-out (1,600 ac)", 1600))) {
  scen <- sc[[1]]; A <- sc[[2]]
  add(S, "Capacity", paste(scen, "—", TILT), "MW_dc", rep(0.25 * A, N), "A", "0.25 MW_dc/acre")
  add(S, "Annual energy", paste(scen, "—", TILT), "MWh/yr", 0.25 * A * y_tilt_p, "C")
  mw_v <- dens_v_p * A
  add(S, "Capacity", paste(scen, "—", VERT), "MW_dc", mw_v, "C", "wider row spacing")
  add(S, "Annual energy", paste(scen, "—", VERT), "MWh/yr", mw_v * y_tilt_p * r_vert_p, "C",
      "high-albedo salt crust favours bifacial")
  add(S, "Playa soil-water evaporation avoided", paste(scen, "—", VERT), "acre-ft/yr", A * shade_v * e_pl * g_red, "C")
  fat_v <- mw_v * R_base * M_gsl * M_vert
  add(S, "Avian fatalities", paste(scen, "—", VERT), "birds/yr", fat_v, "C", "orientation effect on birds unmeasured")
  fat_t <- 0.25 * A * R_base * M_gsl
  add(S, "Avian fatalities per GWh", paste(scen, "—", TILT), "birds/GWh", fat_t / (0.25 * A * y_tilt_p / 1000), "C")
  add(S, "Avian fatalities per GWh", paste(scen, "—", VERT), "birds/GWh", fat_v / (mw_v * y_tilt_p * r_vert_p / 1000), "C")
  add(S, "Area for energy equal to tilted", paste(scen, "—", VERT), "acres",
      A * (0.25 * y_tilt_p) / (dens_v_p * y_tilt_p * r_vert_p), "C")
}
add(S, "PM10 emission avoided within array footprint", paste("operations —", VERT), "% of footprint emission",
    100 * f_dust_v, "C", "rows act as sand fences")

## ---- output -----------------------------------------------------------------
out <- do.call(rbind, results)
print(out[, c("site", "scenario", "quantity", "median", "lo95", "hi95", "unit", "grade")],
      row.names = FALSE)
write.csv(out, "ecological_projections_results.csv", row.names = FALSE)

## ---- sensitivity: rank correlation of inputs with headline outputs ------------
ld_full <- 62.45 * E_ld * s_under * (1 + halo)
cat("\nLittle Dell full build-out evaporation saved — Spearman rho with inputs:\n")
print(round(sapply(list(suppression = s_under, evap_depth = E_ld, downwind_halo = halo),
                   function(v) cor(v, ld_full, method = "spearman")), 2))
cat("\nGreat Salt Lake full build-out avian fatalities — Spearman rho with inputs:\n")
print(round(sapply(list(desert_rate = R_base, GSL_multiplier = M_gsl),
                   function(v) cor(v, 402 * R_base * M_gsl, method = "spearman")), 2))
