# Quantitative Ecological Projections — Little Dell Reservoir and Great Salt Lake

**Date:** 5 November 2026 (revised for the elevated, pile-mounted design)  
**Method:** Monte Carlo uncertainty propagation, 100,000 draws, seed 20261105. Reference implementation in base R: `analysis/ecological_projections.R`. Results: `analysis/ecological_projections_results.csv`.

## Design basis

Every array over water is **elevated**: modules on fixed racks several feet above the highest design water level, carried on piles fixed in the bed. Nothing rests on the water surface. Compared with a floating array, the water beneath stays open to air and wind. That preserves reaeration, so the oxygen penalty is far smaller, but it also lets wind keep driving evaporation, so less water is saved.

## How to read the intervals

Each value is a **median with a 95% uncertainty interval (UI)** — the 2.5th and 97.5th percentiles of outputs when every uncertain input is sampled from a distribution set from the literature. No site measurements exist yet, so these are not sampling-based confidence intervals; they express how uncertain the projection is given current knowledge.

| Grade | Meaning |
|---|---|
| A | Deterministic (geometry) |
| B | Inputs taken from field measurements of the same design — none qualify yet, because no elevated over-water array has been measured over a lake |
| C | Analogue transfer or structural prior — the interval reflects assumptions, not data. Treat as a bounded guess to be replaced by monitoring. |

## How the water estimates have changed

| Basis | Suppression beneath panels | Little Dell full build-out | GSL F1 |
|---|---|---|---|
| Original site plans (floating, assumed) | 80% | ≈150 acre-ft/yr | ≈16 acre-ft/yr |
| Floating, re-based on the one full-scale field measurement (44%) | ≈55% | ≈111 acre-ft/yr | ≈9 acre-ft/yr |
| **Elevated, pile-mounted (current)** | **≈40%** | **70.9 [31.4, 122] acre-ft/yr** | **5.64 [2.50, 9.74] acre-ft/yr** |

## Little Dell Reservoir

### Key findings

- Water saved is modest, and smaller than a floating cover would give. Full build-out saves 70.9 [31.4, 122] acre-ft/yr — about 10.9% of the reservoir's own evaporation and 0.080 [0.035, 0.139]% of SLCDPU's annual water delivery. Zone A saves 14.1 [6.27, 24.2] acre-ft/yr. Wind still passes beneath an elevated canopy, so suppression (≈40%) sits below the 44% measured under a full-scale floating array. No measurement exists for elevated arrays over a lake, so every water figure is grade C.
- The oxygen penalty is small. With the water surface open to the air, the projected deficit beneath the array is 0.408 [0.086, 0.868] mg/L — about a third of the 1.1–1.7 mg/L measured under floating arrays. Across the whole reservoir it is 0.075 [0.015, 0.180] mg/L. The hypolimnetic DO trigger stays as a precaution.
- Algae: direction is uncertain. Light under the panels falls by about 60% — less than under floats, because diffuse and side light reach the water. Measured chlorophyll-a responses at real over-water sites range from an 80% decrease to increases. Reservoir-wide primary production is projected to change -8.76 [-15.2, -4.17]% — fewer blooms, but less food at the base of the food web.
- Piles are the new footprint. Zone A needs 309 [108, 648] piles; full build-out 1,548 [543, 3,249]. They occupy only 819 [194, 2,720] m² of bed at full build-out, but installing them resuspends sediment and makes underwater noise — managed with drilled or vibratory installation, silt curtains and timing.
- Fish and insects: the model cannot tell you the sign. Cooling helps cold-water trout and oxygen loss hurts them; piles add cover and also concentrate predators. The intervals for trout habitat and insect emergence are the assumed ranges, centred near zero — read them as "unknown" until monitoring replaces them.

### Projections

#### Water conservation

| Quantity | Zone A (5%) | Full build-out (25%) | Unit | Grade |
|---|---|---|---|---|
| Evaporation saved | 14.1 [6.27, 24.2] | 70.9 [31.4, 122] | acre-ft/yr | C |
| Share of reservoir's own evaporation | 2.17 [0.984, 3.56] | 10.9 [4.93, 17.9] | % | C |
| Share of storage capacity (20,500 af) | 0.069 [0.031, 0.118] | 0.346 [0.153, 0.593] | % | C |
| Share of SLCDPU annual water delivery | 0.016 [0.0071, 0.028] | 0.080 [0.035, 0.139] | % | C |

#### Light, temperature and algae

| Quantity | Zone A (5%) | Full build-out (25%) | Unit | Grade |
|---|---|---|---|---|
| Light (PAR) reduction under array | 60.3 [39.8, 78.6] | 60.3 [39.8, 78.6] | % | C |
| Surface temperature change under array (summer day) | -0.533 [-1.28, 0.041] | -0.533 [-1.29, 0.040] | °C | C |
| Reservoir-mean surface temperature change | -0.019 [-0.053, 0.0015] | -0.098 [-0.265, 0.0073] | °C | C |
| Chlorophyll-a change under array | -19.9 [-69.0, 29.0] | -20.0 [-69.2, 29.0] | % | C |
| Reservoir-wide chlorophyll-a change | -0.995 [-3.45, 1.45] | -5.01 [-17.4, 7.27] | % | C |
| Reservoir-wide primary production change | -1.75 [-3.03, -0.829] | -8.76 [-15.2, -4.17] | % | C |

#### Oxygen, fish and insects

| Quantity | Zone A (5%) | Full build-out (25%) | Unit | Grade |
|---|---|---|---|---|
| Dissolved-oxygen deficit under array | 0.408 [0.087, 0.866] | 0.408 [0.086, 0.868] | mg/L | C |
| Reservoir-mean dissolved-oxygen deficit | 0.015 [0.0031, 0.036] | 0.075 [0.015, 0.180] | mg/L | C |
| Net summer cold-water (trout) habitat change | -0.00056 [-1.94, 1.94] | -0.0078 [-9.72, 9.74] | % of reservoir | C |
| Aquatic-insect emergence, reservoir-wide | -1.01 [-2.90, 0.900] | -4.99 [-14.5, 4.51] | % | C |
| Water surface beneath the canopy (stays open to wildlife) | 12.4 [12.4, 12.4] | 62.5 [62.5, 62.5] | acres | A |

#### Structure

| Quantity | Zone A (5%) | Full build-out (25%) | Unit | Grade |
|---|---|---|---|---|
| Piles required | 309 [108, 648] | 1,548 [543, 3,249] | piles | C |
| Reservoir bed occupied by piles | 163 [38.8, 542] | 819 [194, 2,720] | m² | C |

### Birds and migration

- Little Dell is not a major migration stopover. With racks several feet above the water, waterfowl can still use the water beneath the canopy (12.45 acres at Zone A, 62.45 at full build-out), though some will avoid it.
- The material bird issue is perching: gulls and cormorants on rack edges drop guano — nutrients and faecal indicator bacteria — straight into a culinary source. Perimeter deterrent wire or spikes and coliform monitoring at the intake are the response. No defensible loading estimate exists without site bird counts.
- Shielded, motion-activated lighting only at the onshore compound; no lighting on the racks.

**What drives the uncertainty:** for water saved, the evaporation-suppression coefficient beneath the elevated canopy (Spearman ρ = 0.93) dominates evaporation depth (0.30) and downwind sheltering (0.14). Measuring suppression at Zone A narrows every water number at once.

## Great Salt Lake

### Key findings

- Solar over the water cannot meaningfully move the lake. F1 saves 5.64 [2.50, 9.74] acre-ft/yr — about 0.00011 inches of lake level per year. Offsetting just 1 ft of decline per decade would take 53,163 [30,790, 119,915] acres of elevated over-water PV, or 8.55 [4.86, 19.4]% of the current lake surface — roughly 12–48 GW of panels on piles. That is the clearest quantitative argument for prioritising upstream water, including agrivoltaics, over building on the lake.
- The playa arrays may save more water than F1 does. Shading the playa reduces evaporation of shallow groundwater: 82.5 [21.4, 236] acre-ft/yr at full build-out, roughly an order of magnitude more than F1. Whether that water reaches the lake is unknown, and the estimate is prior-driven.
- Birds are the governing impact, and the interval is wide. Projected fatalities at full build-out are 904 [177, 4,593] birds/yr. Almost all of that spread comes from one unmeasured number: how much higher fatality rates are beside a major waterbird concentration than at the desert sites the base rates come from (rank correlation 0.84). Phase 1 monitoring exists to measure exactly that.

### Projections

#### Water conservation

| Quantity | Median [95% UI] | Unit | Grade |
|---|---|---|---|
| F1 (5 ac) evaporation saved | 5.64 [2.50, 9.74] | acre-ft/yr | C |
| F1 saving as share of lake evaporation | 0.00023 [9.8e-05, 0.00041] | % | C |
| F1 equivalent lake-level change | 0.00011 [4.8e-05, 0.00019] | inches/yr | C |
| Playa soil-water evaporation avoided — P1 | 20.6 [5.35, 59.0] | acre-ft/yr | C |
| Playa soil-water evaporation avoided — full build-out | 82.5 [21.4, 236] | acre-ft/yr | C |
| Over-water PV area needed to offset 1 ft of lake decline per decade | 53,163 [30,790, 119,915] | acres | C |
| … as share of current lake surface | 8.55 [4.86, 19.4] | % | C |

#### Light, algae, dust and structure

| Quantity | Median [95% UI] | Unit | Grade |
|---|---|---|---|
| F1 effect on lake-wide primary production | -0.00048 [-0.00065, -0.00031] | % | C |
| PM10 emission avoided within array footprint | 49.9 [21.5, 78.5] | % of footprint emission | C |
| F1 piles required | 124 [43.4, 260] | piles | C |

#### Birds

| Quantity | Median [95% UI] | Unit | Grade |
|---|---|---|---|
| Avian fatalities — P1 (100 MW) | 225 [44.0, 1,142] | birds/yr | C |
| … of which water-associated species | 74.2 [12.0, 429] | birds/yr | C |
| Avian fatalities — full build-out (402 MW) | 904 [177, 4,593] | birds/yr | C |
| … of which water-associated species | 298 [48.3, 1,723] | birds/yr | C |
| … as share of ~12 million annual lake users | 0.0075 [0.0015, 0.038] | % | C |

### Migration calendar

| Species group | When | Why it matters here |
|---|---|---|
| Wilson's phalarope | Staging in early-to-late summer before migration to South America | The lake is the species' principal staging site; one estimate holds up to 60% of the world population there at once. |
| Eared grebe | Fall staging September–November; departure late November–early January, after sunset on calm, clear nights | Monthly averages of about 968,000 (Sept), 320,000 (Oct) and 524,000 (Nov); long-run staging estimates of ~1.4 million (1997–2012 average) to 2.6–5.6 million (2013–2017 counts). |
| Shorebirds (avocet, stilt, snowy plover) | Spring–summer breeding; snowy plover nests on open playa | Direct overlap with playa array footprint — the primary habitat-loss pathway. |

### Birds and migration disruption

- Mass grounding is the tail risk the fatality model does not capture. Eared grebes cannot take off from land. On 12 December 2011, a storm grounded thousands of migrating grebes on snow-covered, lit parking lots around St. George and Cedar City; roughly 1,500 died and 3,000–3,500 were rescued. A 1,600-acre dark, reflective array on the departure corridor is a plausible grounding surface under low cloud. One such event would equal about 1.7 years of the projected median background fatalities at full build-out, or about 6.7 years at P1. No defensible rate can be estimated; it should be treated as a design constraint, not a statistic.
- Mitigations that target migration specifically: fragment the array with open corridors rather than one contiguous block; white edge-banding or gridding to break up water-like reflections; no array lighting and only shielded, motion-activated lighting at the substation; underground collector lines and marked (bird-flight-diverter) conductors on any new overhead gen-tie, since waterbirds are among the most power-line-collision-prone groups; and no construction during peak staging (July–August for phalaropes, September–November for grebes). F1's racks over the water are small, but get the same anti-perch and marking treatment.
- Insect food supply: polarised reflections from panels draw aquatic insects to lay eggs on panels instead of water. In one field study, black-framed cells drew 6.9 times more mayfly landings than white-framed ones. Brine flies are a principal food for phalaropes and other shorebirds here, so white gridding serves both insects and birds. No interval is given: there is a single study and no brine-fly data.

**What drives the uncertainty:** for bird fatalities, the unmeasured Great Salt Lake multiplier (ρ = 0.84) dominates the desert base rate (0.51). For the over-water PV area estimate, suppression again dominates (ρ = −0.93), ahead of brine salinity, evaporation depth and downwind sheltering.

## Input distributions

| Parameter | Distribution | Basis |
|---|---|---|
| Evaporation suppression beneath an elevated canopy | Beta(mean 0.40, SD 0.12) | No lake measurement for elevated arrays. Analogues: 44% measured under a full-scale floating array; 44–90% assumed for fully covered canals (McKuin et al. 2021). Set lower because wind passes beneath an open-sided canopy |
| Downwind sheltering bonus | Triangular(0, 0.05, 0.25) | Small: air moves freely under the canopy (35% was measured over open water beside a floating array) |
| Light (PAR) reduction under the canopy | Beta(mean 0.60, SD 0.10) | Below the 73% measured under a floating array; diffuse and side light reach the water, and reservoir pile arrays are deliberately spaced to admit light |
| Under-array surface ΔT (summer day) | Triangular(−1.5, −0.4, +0.2) °C | 0.4 °C cooler measured beneath floating panels in Japanese ponds; shading cools, open sides keep air exchange |
| Under-array chlorophyll-a change | Normal(−20%, 25%), clipped to [−85%, +50%] | Field range under floating arrays from −80% to increases (Cagle et al. 2025) |
| Under-array DO deficit | Triangular(0.0, 0.3, 1.0) mg/L | 1.1–1.7 mg/L under floating arrays (Lake Maiwald) comes largely from lost reaeration, which an open surface preserves |
| Piles per acre | Triangular(5, 15, 60) | ≈8/acre for large truss platforms at the HG14 offshore array; short-span pond racks need more |
| Pile diameter | Uniform(0.5, 1.2) m | Typical precast or steel pipe piles |
| Little Dell gross evaporation | Triangular(2.0, 2.6, 3.3) ft/yr | High-elevation (~5,790 ft) reservoir with winter ice cover; unmeasured |
| GSL freshwater-equivalent evaporation | Triangular(3.0, 3.33, 4.17) ft/yr | 36–50 in, ~40 in central (USGS-era water budgets) |
| GSL brine evaporation factor | Uniform(0.65, 0.85) | Near-saturated brine evaporates ~70% of fresh water |
| GSL surface area | Uniform(550,000, 700,000) acres | Near 4,191.6 ft stage |
| GSL total evaporation | Uniform(2.0, 3.0) million af/yr | State fact sheet (~2 MAF) vs USGS-era (~3 MAF) |
| Desert PV fatality rate | Lognormal(median 1.5, 97.5th 3.5) birds/MW/yr | Kosciuch et al. 2020: high-end 2.49; 1.8–2.5 across California sites |
| GSL waterbird multiplier | Lognormal(median 1.5, 97.5th 6.0) | **No data** — allows rates up to the 9.9 birds/MW/yr reported at one PV site |
| Water-associated share of fatalities | Beta(mean 0.35, SD 0.12) | <13% in desert; assumed higher at GSL |
| Playa groundwater evaporation | Triangular(0.1, 0.3, 1.0) ft/yr | Discharge-playa range; unmeasured here |

## Not estimated, and why

- **Fish aggregation around piles:** no field study measuring fish abundance beneath over-water arrays was found; the OSU/USGS modelling team has called for a real-world installation to test predictions.
- **Underwater noise exposure during pile installation:** depends on the method (impact, vibratory or drilled), pile size and bathymetry; set by an acoustic assessment, not this model.
- **Guano and coliform loading at Little Dell:** requires site bird counts.
- **Mass-grounding event frequency at GSL:** a rare-event process with no rate data; treated as a design constraint.
- **Brine fly response to polarised panels:** one relevant mitigation study (mayflies), no brine-fly data.

## Sources

- [China commissions world's largest 1 GW open-sea offshore solar project (HG14, fixed piles), pv magazine](https://www.pv-magazine.com/2025/12/29/china-commissions-worlds-largest-1-gw-open-sea-offshore-solar-project/)
- [World's first 1 GW offshore solar farm online, Electrek](https://electrek.co/2025/12/30/china-brings-the-worlds-first-1-gw-offshore-solar-farm-online/)
- [A fishery in China deploys a 70 MW pile-mounted solar plant](https://vietnamagriculture.nongnghiep.vn/a-fishery-in-china-just-deployed-a-giant-70mw-solar-plant-d326661.html)
- [McKuin et al. (2021), Energy and water co-benefits from covering canals with solar panels, Nature Sustainability](https://escholarship.org/content/qt8cj5j07p/qt8cj5j07p.pdf?t=qq63ir)
- [EGU26-11025: eddy-covariance evaporation measurements over an industrial-scale FPV reservoir](https://meetingorganizer.copernicus.org/EGU26/EGU26-11025.html)
- [Lake Maiwald FPV field measurements, KIT](https://publikationen.bibliothek.kit.edu/1000182956/162166507)
- [Site-specific relationships between algal biomass and FPV, Frontiers in Water (2025)](https://www.frontiersin.org/journals/water/articles/10.3389/frwa.2025.1614008/full)
- [FPV and phytoplankton in Japanese irrigation ponds, World Lake Conference 2025](https://world-lakes-2025.p.asnevents.com.au/days/2025-07-23/abstract/122128)
- [OSU/USGS (2025), floating solar impacts vary by location](https://news.oregonstate.edu/news/floating-solar-panels-show-promise-environmental-impacts-vary-location-study-finds)
- [Great Salt Lake water budget, USGS Open-File Report 95-428](https://pubs.usgs.gov/of/1995/0428/report.pdf)
- [Great Salt Lake fact sheet, State of Utah](https://greatsaltlake.utah.gov/wp-content/uploads/GSL-Fact-Sheet.pdf)
- [Water conservation FAQ and supply figures, Salt Lake City Public Utilities](https://www.slc.gov/utilities/conservation/water-conservation-faq/)
- [SLCDPU water supply committee summary (2026), Utah Public Notice](https://www.utah.gov/pmn/files/1444021.pdf)
- [Kosciuch et al. (2020), bird mortality at PV facilities, PLOS ONE](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7182256/)
- [Abundance, distribution and migration patterns of North American eared grebes, Waterbirds](https://bioone.org/journals/waterbirds/volume-44/issue-1/063.044.0107/Abundance-Distribution-and-Migration-Patterns-of-North-American-Eared-Grebes/10.1675/063.044.0107.full)
- [Coordinated phalarope surveys at western North American staging sites, 2019–2020](https://www.southbayrestoration.org/document/coordinated-phalarope-surveys-western-north-american-staging-sites-2019-2020)
- [Ornithologist discusses causes of bird downings, NPR (2011)](https://www.npr.org/2011/12/15/143795309/ornithologist-discusses-causes-of-bird-downings)
- [Horváth group: polarised light pollution from solar panels, J. Insect Conservation](https://arago.elte.hu/sites/default/files/MattSolarPanel_JIC.pdf)
