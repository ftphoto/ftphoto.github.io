#!/usr/bin/env node
// Composites a print image into the mat opening of a photographed frame
// mockup, so a new supplier mockup photo never has to be manually
// re-shot/re-edited per artwork. Only works for mockups shot straight-on
// (no perspective in the mat opening) — see mockups/README.md.
//
// Single mockup:
//   node scripts/compose-mockup.mjs --template mockups/templates/black-walnut.jpg \
//     --rect 320,210,1400,980 --image images/portugal_1.jpg --out mockups/output/portugal_1-black-walnut.jpg
//
// All mockups defined in mockups/templates.json for one print:
//   node scripts/compose-mockup.mjs --config mockups/templates.json \
//     --image images/portugal_1.jpg --out-dir mockups/output
//
// Flags:
//   --no-relight   skip the shadow/vignette relight pass (flat paste)

import sharp from 'sharp';
import { readFile, mkdir } from 'node:fs/promises';
import { basename, extname, join } from 'node:path';

function parseArgs(argv) {
  const args = {};
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (!arg.startsWith('--')) continue;
    const key = arg.slice(2);
    if (key === 'no-relight') {
      args.relight = false;
      continue;
    }
    args[key] = argv[++i];
  }
  return args;
}

function parseRect(spec) {
  const [x, y, width, height] = spec.split(',').map(Number);
  if ([x, y, width, height].some((n) => !Number.isFinite(n))) {
    throw new Error(`Invalid --rect "${spec}", expected "x,y,width,height"`);
  }
  return { x, y, width, height };
}

async function composeMockup({ templatePath, rect, imagePath, outPath, relight = true }) {
  const { x, y, width, height } = rect;

  const fitted = await sharp(imagePath)
    .resize(width, height, { fit: 'cover', position: 'centre' })
    .toBuffer();

  let layer = fitted;

  if (relight) {
    // Turn the mockup's own window region into a normalized light map
    // (brightest pixel -> white/no change, darker pixels -> gray) and
    // multiply it over the new photo, so the frame photo's original
    // shadow/vignette carries over instead of a flat, pasted-on look.
    const { data, info } = await sharp(templatePath)
      .extract({ left: x, top: y, width, height })
      .greyscale()
      .raw()
      .toBuffer({ resolveWithObject: true });

    let max = 1;
    for (let i = 0; i < data.length; i++) if (data[i] > max) max = data[i];
    const scaled = Buffer.alloc(data.length);
    for (let i = 0; i < data.length; i++) {
      scaled[i] = Math.min(255, Math.round((data[i] / max) * 255));
    }
    const lightMap = await sharp(scaled, {
      raw: { width: info.width, height: info.height, channels: 1 }
    })
      .toColourspace('b-w')
      .png()
      .toBuffer();

    layer = await sharp(fitted).composite([{ input: lightMap, blend: 'multiply' }]).toBuffer();
  }

  await sharp(templatePath)
    .composite([{ input: layer, left: x, top: y }])
    .jpeg({ quality: 92 })
    .toFile(outPath);
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const relight = args.relight !== false;

  if (!args.image) {
    throw new Error('--image <path> is required');
  }

  if (args.config) {
    const config = JSON.parse(await readFile(args.config, 'utf8'));
    const only = args.only ? new Set(args.only.split(',')) : null;
    const outDir = args['out-dir'] || 'mockups/output';
    await mkdir(outDir, { recursive: true });

    const stem = basename(args.image, extname(args.image));
    for (const [name, entry] of Object.entries(config)) {
      if (only && !only.has(name)) continue;
      const outPath = join(outDir, `${stem}-${name}.jpg`);
      await composeMockup({
        templatePath: entry.template,
        rect: entry.rect,
        imagePath: args.image,
        outPath,
        relight
      });
      console.log(`wrote ${outPath}`);
    }
    return;
  }

  if (!args.template || !args.rect || !args.out) {
    throw new Error('Either --config, or --template/--rect/--out, must be provided');
  }

  await composeMockup({
    templatePath: args.template,
    rect: parseRect(args.rect),
    imagePath: args.image,
    outPath: args.out,
    relight
  });
  console.log(`wrote ${args.out}`);
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
