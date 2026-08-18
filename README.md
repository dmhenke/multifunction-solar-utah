# multifunction-solar-utah

Pre-feasibility site plans and strategy for solar development on Utah's public waters and working lands, where generation serves more than one function — power production paired with water conservation, dust suppression, or ecosystem enhancement.

**Live site:** https://dmhenke.github.io/multifunction-solar-utah

---

## What this is

Two Class 5 pre-feasibility site plans (AACE International; expected accuracy −30% / +50%) and the strategy that connects them.

| Site | Configuration | Capacity | Annual energy |
|---|---|---|---|
| **Little Dell Reservoir** | Floating PV, 3 zones, 25.1% coverage | 24.98 MW_dc | ≈41,200 MWh |
| **Great Salt Lake** | Playa ground-mount + near-shore FPV research module | 402 MW_dc | ≈743,300 MWh |

All geometry is **schematic**. Contours, shorelines, bathymetry and infrastructure positions must be replaced with LiDAR, survey and cadastral data before any permitting use.

---

## Repository structure

```
multifunction-solar-utah/
├── index.html                          Tabbed site (Overview / Little Dell / Great Salt Lake)
├── .nojekyll                           Serve files as-is on GitHub Pages
├── README.md
├── assets/
│   ├── little-dell-fpv-site-plan.svg
│   └── great-salt-lake-solar-site-plan.svg
└── docs/
    ├── 00-overview.md                  Strategy summary
    ├── 00-strategy-playbook.md         Full playbook: stakeholders, funding, counterarguments, R model
    ├── 01-little-dell-summary.md
    ├── 01-little-dell-full.md          Full site plan
    ├── 02-great-salt-lake-summary.md
    └── 02-great-salt-lake-full.md      Full site plan
```

---

## Core findings

### Framing

Utah faces two simultaneous constraints — load growth under Operation Gigawatt, and a terminal-lake water crisis in which agriculture accounts for most consumptive depletion. Multifunction solar produces both electrons and consumptively-saved water from the same capital investment.

The operative question is not "should we cover a lake" but **what is the marginal cost of a saved acre-foot and a delivered megawatt-hour, jointly, across the portfolio of candidate deployments — and which sites clear that bar?**

### Little Dell Reservoir

- 20,500 acre-feet, ≈249 surface acres, mean depth 82 ft
- Zone A demonstration: 12.45 ac, 4.98 MW_dc, ≈8,200 MWh/yr
- Full build-out: 62.45 ac (25.1%), 24.98 MW_dc, ≈41,200 MWh/yr
- Evaporation saved at full build-out: **≈150 acre-feet/yr — about 0.02% of service-area supply**

**Do not present Little Dell as water conservation.** The defensible case is distributed generation near load, algal and DBP-precursor suppression, and research value. The governing constraint is that this is a culinary source: the materials protocol, not the economics, decides the project.

**Recommended sequence:** demonstrate on SLCDPU's own non-culinary surfaces first (treatment basins, backwash ponds), then return to Little Dell with their own operating data.

### Great Salt Lake

Large-scale open-water floating PV is **not viable**, defeated independently by hydrodynamics (shallow, high-fetch basin), materials (>0.6 mm/yr steel corrosion in brine, no multi-year operating record anywhere), ecology (unquantified shading effects on the food web supporting ~12 million birds), and public trust doctrine.

Proposed instead:
- **Playa ground-mount above the 4,200 ft contour** — 1,600 ac, 400 MW_dc, ≈740,000 MWh/yr, with dust suppression as the co-benefit
- **5-acre near-shore FPV research module** — 2 MW_dc, answering brine-service durability and ecological questions at a scale where failure is informative

**Governing principle:** *No infrastructure sited at Great Salt Lake may create an economic interest opposed to raising the lake.* Enforced by a 4,200 ft development limit, lease subordination to elevation management, inundation waiver, removal bond, and a political-activity covenant.

The governing ecological question for playa arrays is **avian attraction and collision** (polarized-light "lake effect"), not shading.

### The strongest thesis in the portfolio

**Agrivoltaics on Utah farmland is a more powerful Great Salt Lake water intervention than floating solar on the Great Salt Lake itself.** Shading irrigated crops cuts crop ET 20–50% in arid climates — a reduction in *consumptive* use, acting on the dominant lever, with an existing legal channel to dedicate the saved water instream.

---

## Immediate action

The Great Salt Lake Comprehensive Management Plan and Mineral Leasing Plan are **under active update**. Submitting comments to establish renewable energy as a defined, evidence-gated use category on sovereign lands is the highest-leverage single engagement available, and it is date-driven.

---

## Local preview

```bash
python3 -m http.server 8000
# open http://localhost:8000
```

## Deploy to GitHub Pages

Settings → Pages → Source: *Deploy from a branch* → Branch: `main`, folder `/ (root)`.

---

## Status and limitations

Class 5 pre-feasibility. Not for construction, permitting, or investment decisions. Each site plan carries an explicit data-gap list that must be closed before the numbers can be relied on. Several figures — notably Great Salt Lake evaporation volume and Little Dell gross evaporation depth — are flagged as unverified and traced to their sources in the full documents.

## License

Released for public discussion and comment. Adapt freely for research, advocacy, or project development.
