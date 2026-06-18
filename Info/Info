# Overview

- Reads from one json file
- `src/app.html` - the bare HTML shell.
- `src/app.css` - global CSS.
- `src/routes/+layout.svelte` - runs on every page. Fetches journeys.json on startup and loads it into the app.
- `src/routes/+layout.ts` - SvelteKit prerenders everything as a static site.

## Pages

`src/routes/+page.svelte` - home page. Just renders `<HomeScreen>`.

`src/routes/journey/[id]/+page.svelte` — the journey detail page. The `[id]` in the folder name is dynamic

`src/lib/stores/app.svelte.ts` - holds all the shared state in one place. Includes all the UI:

- The loaded data (journeys, nodes, categories, jurisdictions)
- Which journey is currently active
- Which node/step is selected
- Filter state
- View mode (standard vs. dependency)

## Components

`HomeScreen.svelte` - two-column home layout.

`JourneyRow.svelte` - Row in journey list: name, category, and how many steps it has.

`JourneyScreen.svelte` - full journey detail view. Renders MatrixGrid as the main content and NodeDetailPanel when a node is selected.

`MatrixGrid.svelte` - renders the grid where rows are jurisdictions and cols are phases

`NodeCard.svelte` - single step

`NodeDetailPanel.svelte` - a slide-in panel when click a node

`FlowPathOverlay.svelte` — draws arrows between node cards? We might want to delete this

`DependencyLegend.svelte` — the small legend that explains what hard/soft/parallel arrows mean.

`SourcesPanel.svelte` - list of references/sources

## Utility Functions

`topoSort.ts` - takes the list of steps in a journey and sorts them in the correct order based on their dependencies.

`topoLevels.ts` - takes sorted steps and groups them into "levels"/columns

`matrix.ts` - uses journey to build phase×jurisdiction grid

`pathCalc.ts` - parses time strings (ex. 3 months) into number of weeks for timeline calculations

`timeline.ts` - calculates timing estimates across the whole journey

`src/lib/components/ui/` - pre-built components might not need and could delete if we don't want to use them

# Current data flow:

`static/data/journeys.json` holds the static data

In the root layout ← data in fetched onMount(() in `src/routes/+layout.svelte`

`.json()` parses the response into JS object

In `app.svelte.ts` `loadData(data)` it received teh parsed object as data

## Current Data

4 sections: jurisdiction, categories, plcNodes (steps: each node has jurisdiction, phase, estimated time, fee, etc.), journeys (named sequence of node IDs)

## Plan to update data

To change the data and load in a csv we would just need to make two csvs that mirror plcNodes and journeys

Write a Node.js script that reads the csvs and writes a .json that can be passed as data into `loadData(data)`
