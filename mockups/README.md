# Frame mockup templating

Turns your supplier's frame mockup photos into reusable templates: any print
gets composited into the mat opening automatically, instead of you (or a
tool like Placeit) redoing the mockup by hand for every piece of work.

This only works cleanly because the supplier photos are shot **straight-on**
— the mat opening is an axis-aligned rectangle, not a perspective-warped
one. If a mockup is shot at an angle, this script will paste a flat
rectangle into it and it'll look wrong; you'd need a perspective-warp step
instead.

## One-time setup per frame finish

1. Drop the supplier photo in `mockups/templates/`, e.g.
   `mockups/templates/black-walnut.jpg`.
2. Open it in any image viewer/editor that shows pixel coordinates
   (Preview, Photoshop, even browser dev tools) and find the **inside edge
   of the mat opening** — i.e. where the actual photo paper starts, not the
   outer wood frame or the mat board.
   - Note the pixel coordinates of the top-left corner (`x`, `y`) and the
     opening's `width`/`height` in pixels.
3. Copy `mockups/templates.json.example` to `mockups/templates.json` (this
   file is gitignored — see below) and fill in the `rect` for each finish.

## Generating a mockup

For one print, across every finish in `mockups/templates.json`:

```
node scripts/compose-mockup.mjs --config mockups/templates.json \
  --image images/portugal_1.jpg --out-dir mockups/output
```

For a single template/finish without a config file:

```
node scripts/compose-mockup.mjs --template mockups/templates/black-walnut.jpg \
  --rect 320,210,1400,980 --image images/portugal_1.jpg \
  --out mockups/output/portugal_1-black-walnut.jpg
```

Output files land in `mockups/output/<image-name>-<finish>.jpg`.

## Why the composite looks real

A flat paste of a new photo into the opening ignores the ambient light and
soft shadow already baked into the supplier's photo, which is what makes
copy-pasted mockups look fake. The script pulls the *original* window
region out of the mockup, normalizes it into a light map, and multiplies
that over the new photo before pasting — so the same shadow/vignette from
the source photo carries over. Pass `--no-relight` to skip this and paste
flat instead.

## Notes

- `mockups/templates/` (your source mockup photos) and
  `mockups/templates.json` (your rects) are yours to fill in locally or add
  to the repo — they aren't committed by default since the rects are
  specific to files you haven't provided yet.
- `mockups/output/` is gitignored — it's generated output, not source.
- This is a standalone marketing-asset tool. It's separate from the
  CSS-drawn frame preview already live on `product.html`/`shop.html`,
  which handles the on-site "insert my photo into a frame" preview and
  isn't affected by this.
