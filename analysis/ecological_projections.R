## =============================================================================
## Monte Carlo ecological projections — Little Dell Reservoir & Great Salt Lake
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
## Evaporation suppression over the covered area. Only full-scale field value
## found: 44% (eddy covariance, EGU26-11025). Models and small benches: ~17–90%.
s_under <- rbeta_ms(N, 0.55, 0.13)
## Additional saving from downwind sheltering (EGU26 reports 35% reduction over
## UNcovered water at one site; coverage unstated) — expressed as a bonus fraction.
halo    <- rtri(N, 0.00, 0.15, 0.60)
## Irradiance/PAR reduction under the array (Lake Maiwald field: 73%).
par_red <- rbeta_ms(N, 0.75, 0.07)

## ============================== LITTLE DELL ===================================
S     <- "Little Dell"
A_res <- 249
E_ld  <- rtri(N, 2.0, 2.6, 3.3)                # gross evaporation, ft/yr (≈5,790 ft elev.)

for (sc in list(list("Zone A (5%)", 12.45), list("Full build-out (25%)", 62.45))) {
  scen <- sc[[1]]; A <- sc[[2]]; cov <- A / A_res
  saved <- A * E_ld * s_under * (1 + halo)
  add(S, "Evaporation saved", scen, "acre-ft/yr", saved, "B")
  add(S, "Evaporation saved, share of reservoir evaporation", scen, "%",
      100 * saved / (A_res * E_ld), "B")
  add(S, "Evaporation saved, share of storage capacity", scen, "%",
      100 * saved / 20500, "B")
  delivery <- runif(N, 80000, 97000)           # SLCDPU delivered ~81,600 af (2022), ~97,000 af (2020)
  add(S, "Evaporation saved, share of SLCDPU annual delivery", scen, "%",
      100 * saved / delivery, "B")

  dT_under <- rtri(N, -2.0, -0.6, 0.2)          # °C, summer daytime (field: ~0.4 °C cooler)
  mixw     <- runif(N, 0.5, 1.0)
  add(S, "Surface water temp change under array (summer day)", scen, "°C", dT_under, "B")
  add(S, "Reservoir-mean surface temp change (summer)", scen, "°C", dT_under * cov * mixw, "C")
  add(S, "Light (PAR) reduction under array", scen, "%", 100 * par_red, "B")

  chl_under <- pmin(pmax(rnorm(N, -0.25, 0.25), -0.85), 0.50)   # field: −80% to increases
  add(S, "Chlorophyll-a change under array", scen, "%", 100 * chl_under, "B",
      "sign uncertain; trophic-state dependent")
  add(S, "Reservoir-wide chlorophyll-a change", scen, "%", 100 * chl_under * cov, "C")
  fll <- runif(N, 0.3, 0.9)                     # light-limited share of production
  add(S, "Reservoir-wide primary production change", scen, "%", -100 * cov * par_red * fll, "C")

  do_def <- rtri(N, 0.3, 1.2, 2.2)              # mg/L (Maiwald: 1.1–1.7 lower)
  add(S, "Dissolved-oxygen deficit under array", scen, "mg/L", do_def, "B")
  add(S, "Reservoir-mean DO deficit", scen, "mg/L", do_def * cov * mixw, "C")

  g_t <- runif(N, 0, 0.5); g_o <- runif(N, 0, 0.5)
  add(S, "Net summer cold-water (trout) habitat change", scen, "% of reservoir",
      100 * cov * (g_t - g_o), "C", "structural prior; sign unknown")
  emerg <- runif(N, -0.2, 0.6)
  add(S, "Aquatic-insect emergence change, reservoir-wide", scen, "%", -100 * cov * emerg, "C",
      "prior-driven")
  add(S, "Open water removed from waterfowl use", scen, "acres", rep(A, N), "A", "deterministic")
}

## ============================ GREAT SALT LAKE =================================
S        <- "Great Salt Lake"
E_fresh  <- rtri(N, 3.0, 3.33, 4.17)            # ft/yr freshwater-equivalent (36–50 in)
sal_fac  <- runif(N, 0.65, 0.85)                # brine evaporates ~70% of fresh
E_gsl    <- E_fresh * sal_fac
lake_ac  <- runif(N, 5.5e5, 7.0e5)              # surface area near 4,191.6 ft
tot_evap <- runif(N, 2.0e6, 3.0e6)              # af/yr total evaporation

saved_f1 <- 5 * E_gsl * s_under * (1 + halo)
add(S, "F1 evaporation saved", "F1 (5 ac)", "acre-ft/yr", saved_f1, "B")
add(S, "F1 saving, share of lake evaporation", "F1 (5 ac)", "%", 100 * saved_f1 / tot_evap, "B")
add(S, "F1 equivalent lake-level change", "F1 (5 ac)", "inches/yr", 12 * saved_f1 / lake_ac, "B")
need <- 6e4 / (E_gsl * s_under * (1 + halo))    # 1 ft over 10 yr ≈ 60,000 af/yr
add(S, "FPV area needed to offset 1 ft of decline per decade", "hypothetical", "acres", need, "B")
add(S, "  … as share of current lake surface", "hypothetical", "%", 100 * need / lake_ac, "B")
add(S, "F1 lake-scale primary-production change", "F1 (5 ac)", "%",
    -100 * (5 / lake_ac) * par_red, "B")

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
