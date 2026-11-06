# Quantitative Ecological Projections — Little Dell Reservoir and Great Salt Lake

**Date:** 5 November 2026  
**Method:** Monte Carlo uncertainty propagation, 100,000 draws, seed 20261105. Reference implementation in base R: `analysis/ecological_projections.R`. Results: `analysis/ecological_projections_results.csv`.

## How to read the intervals

Each value is a **median with a 95% uncertainty interval (UI)** — the 2.5th and 97.5th percentiles of outputs when every uncertain input is sampled from a distribution set from the literature. No site measurements exist yet, so these are not sampling-based confidence intervals; they express how uncertain the projection is given current knowledge.

| Grade | Meaning |
|---|---|
| A | Deterministic (geometry) |
| B | Inputs taken from field measurements or validated models |
| C | Analogue transfer or structural prior — the interval reflects assumptions, not data. Treat as a bounded guess to be replaced by monitoring. |

## Correction to earlier figures

The site plans assumed 80% evaporation suppression beneath the panels. The only full-scale field measurement found (eddy covariance over an industrial-scale reservoir, May–October 2025) reports **44%** over the covered area, plus a 35% reduction over uncovered water nearby. This analysis uses suppression ~ Beta(mean 0.55, SD 0.13) plus a downwind-sheltering bonus. The resulting water-saving medians are roughly a quarter (Little Dell) to a half (Great Salt Lake F1) lower than the earlier point estimates of ≈30 / ≈150 acre-ft/yr (Little Dell) and ≈16 acre-ft/yr (F1), which these projections supersede.

## Little Dell Reservoir

### Key findings

- Water saved is about a quarter lower than first estimated. Full build-out saves 111 [56.4, 180] acre-ft/yr — about 17.1% of the reservoir's own evaporation and 0.126 [0.064, 0.205]% of SLCDPU's annual water delivery. Zone A saves 22.2 [11.2, 35.8] acre-ft/yr. The earlier ≈30 and ≈150 acre-ft/yr figures assumed 80% suppression under the panels; the only full-scale field measurement found reports 44%.
- Algae: direction is genuinely uncertain. Light under the panels falls by roughly three-quarters, but measured chlorophyll-a responses at real FPV sites range from an 80% decrease to increases, depending on trophic state and mixing. Reservoir-wide primary production is projected to fall, which means fewer blooms but also less food at the base of the food web.
- Oxygen is the effect to watch. The under-array deficit of about 1.2 mg/L is well supported by field data. Diluted across the reservoir it is small, but it concentrates where the array shelters the surface — exactly where a late-summer hypolimnetic DO trigger is needed.
- Fish and insects: the model cannot tell you the sign. Cooling helps cold-water trout and oxygen loss hurts them; no field study has measured both at a comparable site. The intervals for trout habitat and insect emergence are the assumed ranges, centred near zero, and should be read as "unknown" until monitoring replaces them.

### Projections

#### Water conservation

| Quantity | Zone A (5%) | Full build-out (25%) | Unit | Grade |
|---|---|---|---|---|
| Evaporation saved | 22.2 [11.2, 35.8] | 111 [56.4, 180] | acre-ft/yr | B |
| Share of reservoir's own evaporation | 3.42 [1.78, 5.25] | 17.1 [8.92, 26.3] | % | B |
| Share of storage capacity (20,500 af) | 0.108 [0.055, 0.175] | 0.543 [0.275, 0.877] | % | B |
| Share of SLCDPU annual water delivery | 0.025 [0.013, 0.041] | 0.126 [0.064, 0.205] | % | B |

#### Light, temperature and algae

| Quantity | Zone A (5%) | Full build-out (25%) | Unit | Grade |
|---|---|---|---|---|
| Light (PAR) reduction under array | 75.5 [60.2, 87.3] | 75.5 [60.2, 87.3] | % | B |
| Surface temperature change under array (summer day) | -0.757 [-1.72, -0.0068] | -0.756 [-1.72, -0.0099] | °C | B |
| Reservoir-mean surface temperature change | -0.028 [-0.071, -0.00025] | -0.139 [-0.356, -0.0018] | °C | C |
| Chlorophyll-a change under array | -25.1 [-74.2, 23.7] | -25.1 [-74.1, 24.4] | % | B |
| Reservoir-wide chlorophyll-a change | -1.26 [-3.71, 1.19] | -6.29 [-18.6, 6.12] | % | C |
| Reservoir-wide primary production change | -2.23 [-3.52, -1.14] | -11.2 [-17.7, -5.72] | % | C |

#### Oxygen, fish and insects

| Quantity | Zone A (5%) | Full build-out (25%) | Unit | Grade |
|---|---|---|---|---|
| Dissolved-oxygen deficit under array | 1.23 [0.504, 1.98] | 1.23 [0.507, 1.98] | mg/L | B |
| Reservoir-mean dissolved-oxygen deficit | 0.045 [0.017, 0.084] | 0.224 [0.088, 0.423] | mg/L | C |
| Net summer cold-water (trout) habitat change | 0.00017 [-1.94, 1.94] | -0.0052 [-9.76, 9.74] | % of reservoir | C |
| Aquatic-insect emergence, reservoir-wide | -0.994 [-2.90, 0.902] | -5.04 [-14.5, 4.52] | % | C |
| Open water removed from waterfowl use | 12.4 [12.4, 12.4] | 62.5 [62.5, 62.5] | acres | A |

### Birds and migration

- Little Dell is not a major migration stopover; open-water loss to waterfowl is the array footprint itself (12.45 acres at Zone A, 62.45 at full build-out).
- The material bird issue is perching: gulls, cormorants and waterfowl on array edges deposit guano — nutrients and faecal indicator bacteria — directly into a culinary source. Perimeter deterrent wire or spikes and coliform monitoring at the intake are the response. No defensible loading estimate exists without site bird counts.
- Shielded, motion-activated lighting only at the onshore compound; no lighting on the water.

**What drives the uncertainty:** for water saved, the under-array evaporation suppression coefficient (Spearman ρ = 0.85) dominates evaporation depth (0.35) and downwind sheltering (0.34). Measuring suppression at Zone A narrows every water number at once.

## Great Salt Lake

### Key findings

- Floating solar cannot meaningfully move the lake. F1 saves 8.87 [4.51, 14.4] acre-ft/yr — about 0.00017 inches of lake level per year. Offsetting just 1 ft of decline per decade would take 33,834 [20,848, 66,577] acres of floating PV, or 5.43 [3.28, 10.8]% of the current lake surface — roughly 8–27 GW of panels at FPV power densities. That is the clearest quantitative argument for prioritising upstream water (including agrivoltaics) over covering the lake.
- The playa arrays may save more water than F1 does. Shading the playa reduces evaporation of shallow groundwater: 82.0 [21.3, 236] acre-ft/yr at full build-out, roughly an order of magnitude more than F1. Whether that water reaches the lake is unknown, and the estimate is prior-driven.
- Birds are the governing impact, and the interval is wide. Projected fatalities at full build-out are 911 [179, 4,595] birds/yr. Almost all of that spread comes from one unmeasured number: how much higher fatality rates are beside a major waterbird concentration than at the desert sites the base rates come from (rank correlation 0.84). Phase 1 monitoring exists to measure exactly that.

### Projections

#### Water conservation

| Quantity | Median [95% UI] | Unit | Grade |
|---|---|---|---|
| F1 (5 ac) evaporation saved | 8.87 [4.51, 14.4] | acre-ft/yr | B |
| F1 saving as share of lake evaporation | 0.00036 [0.00018, 0.00061] | % | B |
| F1 equivalent lake-level change | 0.00017 [8.6e-05, 0.00028] | inches/yr | B |
| Playa soil-water evaporation avoided — P1 | 20.5 [5.33, 59.1] | acre-ft/yr | C |
| Playa soil-water evaporation avoided — full build-out | 82.0 [21.3, 236] | acre-ft/yr | C |
| FPV area needed to offset 1 ft of lake decline per decade | 33,834 [20,848, 66,577] | acres | B |
| … as share of current lake surface | 5.43 [3.28, 10.8] | % | B |

#### Light, algae and dust

| Quantity | Median [95% UI] | Unit | Grade |
|---|---|---|---|
| F1 effect on lake-wide primary production | -0.0006 [-0.00074, -0.00047] | % | B |
| PM10 emission avoided within array footprint | 50.1 [21.5, 78.5] | % of footprint emission | C |

#### Birds

| Quantity | Median [95% UI] | Unit | Grade |
|---|---|---|---|
| Avian fatalities — P1 (100 MW) | 227 [44.6, 1,143] | birds/yr | C |
| … of which water-associated species | 74.7 [12.2, 431] | birds/yr | C |
| Avian fatalities — full build-out (402 MW) | 911 [179, 4,595] | birds/yr | C |
| … of which water-associated species | 300 [49.1, 1,734] | birds/yr | C |
| … as share of ~12 million annual lake users | 0.0076 [0.0015, 0.038] | % | C |

### Migration calendar

| Species group | When | Why it matters here |
|---|---|---|
| Wilson's phalarope | Staging in early-to-late summer before migration to South America | The lake is the species' principal staging site; one estimate holds up to 60% of the world population there at once. |
| Eared grebe | Fall staging September–November; departure late November–early January, after sunset on calm, clear nights | Monthly averages of about 968,000 (Sept), 320,000 (Oct) and 524,000 (Nov); long-run staging estimates of ~1.4 million (1997–2012 average) to 2.6–5.6 million (2013–2017 counts). |
| Shorebirds (avocet, stilt, snowy plover) | Spring–summer breeding; snowy plover nests on open playa | Direct overlap with playa array footprint — the primary habitat-loss pathway. |

### Birds and migration disruption

- Mass grounding is the tail risk the fatality model does not capture. Eared grebes cannot take off from land. On 12 December 2011, a storm grounded thousands of migrating grebes on snow-covered, lit parking lots around St. George and Cedar City; roughly 1,500 died and 3,000–3,500 were rescued. A 1,600-acre dark, reflective array on the departure corridor is a plausible grounding surface under low cloud. One such event would equal about 1.6 years of the projected median background fatalities at full build-out, or about 6.6 years at P1. No defensible rate can be estimated; it should be treated as a design constraint, not a statistic.
- Mitigations that target migration specifically: fragment the array with open corridors rather than one contiguous block; white edge-banding or gridding to break up water-like reflections; no array lighting and only shielded, motion-activated lighting at the substation; underground collector lines and marked (bird-flight-diverter) conductors on any new overhead gen-tie, since waterbirds are among the most power-line-collision-prone groups; and no construction during peak staging (July–August for phalaropes, September–November for grebes).
- Insect food supply: polarised reflections from panels draw aquatic insects to lay eggs on panels instead of water. In one field study, black-framed cells drew 6.9 times more mayfly landings than white-framed ones. Brine flies are a principal food for phalaropes and other shorebirds here, so white gridding serves both insects and birds. No interval is given: there is a single study and no brine-fly data.

**What drives the uncertainty:** for bird fatalities, the unmeasured Great Salt Lake multiplier (ρ = 0.84) dominates the desert base rate (0.50). For the floating-PV area estimate, suppression again dominates (ρ = −0.84), ahead of downwind sheltering, brine salinity and evaporation depth.

## Input distributions

| Parameter | Distribution | Basis |
|---|---|---|
| Evaporation suppression over covered area | Beta(mean 0.55, SD 0.13) | 44% full-scale eddy covariance; 17–90% across models and test benches |
| Downwind sheltering bonus | Triangular(0, 0.15, 0.60) | 35% reduction measured over uncovered water at one site |
| PAR reduction under array | Beta(mean 0.75, SD 0.07) | 73% irradiance reduction, Lake Maiwald |
| Little Dell gross evaporation | Triangular(2.0, 2.6, 3.3) ft/yr | High-elevation (~5,790 ft) reservoir with winter ice cover; unmeasured |
| Under-array surface ΔT (summer day) | Triangular(−2.0, −0.6, +0.2) °C | 0.4 °C cooler measured in Japanese ponds; reviews report daytime cooling |
| Under-array chlorophyll-a change | Normal(−25%, 25%), clipped to [−85%, +50%] | Field range from −80% to increases (Cagle et al. 2025; Japanese ponds) |
| Under-array DO deficit | Triangular(0.3, 1.2, 2.2) mg/L | 1.1–1.7 mg/L lower, Lake Maiwald |
| GSL freshwater-equivalent evaporation | Triangular(3.0, 3.33, 4.17) ft/yr | 36–50 in, ~40 in central (USGS-era water budgets) |
| GSL brine evaporation factor | Uniform(0.65, 0.85) | Near-saturated brine evaporates ~70% of fresh water |
| GSL surface area | Uniform(550,000, 700,000) acres | Near 4,191.6 ft stage |
| GSL total evaporation | Uniform(2.0, 3.0) million af/yr | State fact sheet (~2 MAF) vs USGS-era (~3 MAF) |
| Desert PV fatality rate | Lognormal(median 1.5, 97.5th 3.5) birds/MW/yr | Kosciuch et al. 2020: high-end 2.49; 1.8–2.5 across California sites |
| GSL waterbird multiplier | Lognormal(median 1.5, 97.5th 6.0) | **No data** — allows rates up to the 9.9 birds/MW/yr reported at one PV site |
| Water-associated share of fatalities | Beta(mean 0.35, SD 0.12) | <13% in desert; assumed higher at GSL |
| Playa groundwater evaporation | Triangular(0.1, 0.3, 1.0) ft/yr | Discharge-playa range; unmeasured here |

## Not estimated, and why

- **Fish aggregation under the array:** no field study measuring fish abundance beneath FPV was found; the OSU/USGS modelling team has called for a real-world installation to test predictions.
- **Guano and coliform loading at Little Dell:** requires site bird counts.
- **Mass-grounding event frequency at GSL:** a rare-event process with no rate data; treated as a design constraint.
- **Brine fly response to polarised panels:** one relevant mitigation study (mayflies), no brine-fly data.

## Sources

- [EGU26-11025: eddy-covariance evaporation measurements over an industrial-scale FPV reservoir](https://meetingorganizer.copernicus.org/EGU26/EGU26-11025.html)
- [Numerical analysis of evaporation reduction in floating PV, EPJ Photovoltaics (2025)](https://www.epj-pv.org/articles/epjpv/pdf/2025/01/pv20240049.pdf)
- [FPV evaporation reduction, Lake Powell thesis, University of Rhode Island](https://digitalcommons.uri.edu/theses/2738)
- [Lake Maiwald FPV field measurements, KIT](https://publikationen.bibliothek.kit.edu/1000182956/162166507)
- [Site-specific relationships between algal biomass and FPV, Frontiers in Water (2025)](https://www.frontiersin.org/journals/water/articles/10.3389/frwa.2025.1614008/full)
- [FPV and phytoplankton in Japanese irrigation ponds, World Lake Conference 2025](https://world-lakes-2025.p.asnevents.com.au/days/2025-07-23/abstract/122128)
- [OSU/USGS (2025), floating solar impacts vary by location](https://news.oregonstate.edu/news/floating-solar-panels-show-promise-environmental-impacts-vary-location-study-finds)
- [OSU study: floating solar could power millions, but with ecological trade-offs, OPB](https://www.opb.org/article/2025/11/28/oregon-state-university-study-floating-solar-could-power-millions-with-ecological-trade-offs/)
- [Great Salt Lake water budget, USGS Open-File Report 95-428](https://pubs.usgs.gov/of/1995/0428/report.pdf)
- [Great Salt Lake fact sheet, State of Utah](https://greatsaltlake.utah.gov/wp-content/uploads/GSL-Fact-Sheet.pdf)
- [Water conservation FAQ and supply figures, Salt Lake City Public Utilities](https://www.slc.gov/utilities/conservation/water-conservation-faq/)
- [SLCDPU water supply committee summary (2026), Utah Public Notice](https://www.utah.gov/pmn/files/1444021.pdf)
- [Kosciuch et al. (2020), bird mortality at PV facilities, PLOS ONE](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7182256/)
- [Abundance, distribution and migration patterns of North American eared grebes, Waterbirds](https://bioone.org/journals/waterbirds/volume-44/issue-1/063.044.0107/Abundance-Distribution-and-Migration-Patterns-of-North-American-Eared-Grebes/10.1675/063.044.0107.full)
- [Dependence on threatened saline lakes leaves eared grebes at risk, Audubon](https://www.audubon.org/news/dependence-threatened-saline-lakes-leaves-eared-grebes-risk)
- [Coordinated phalarope surveys at western North American staging sites, 2019–2020](https://www.southbayrestoration.org/document/coordinated-phalarope-surveys-western-north-american-staging-sites-2019-2020)
- [Ryan Carle presentation on phalaropes, California Water Boards (2026)](https://www.waterboards.ca.gov/waterrights/water_issues/programs/mono_lake/docs/2026/ryan-carle-presentation.pdf)
- [Ornithologist discusses causes of bird downings, NPR (2011)](https://www.npr.org/2011/12/15/143795309/ornithologist-discusses-causes-of-bird-downings)
- [Mystery surrounds crash landing of thousands of birds in Utah, Star Tribune](https://www.startribune.com/mystery-surrounds-crash-landing-of-thousands-of-birds-in-utah/135746003/)
- [Horváth group: polarised light pollution from solar panels, J. Insect Conservation](https://arago.elte.hu/sites/default/files/MattSolarPanel_JIC.pdf)
- [Fritz et al. (2020), bioreplicated coatings reduce polarised light pollution, PLOS ONE](https://doaj.org/article/71440af2b9ff4fa791a10427f62fd0f4)
