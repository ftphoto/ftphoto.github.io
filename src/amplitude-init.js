import * as amplitude from '@amplitude/unified';

window.amplitude = amplitude;

// Amplitude ingestion key — public by design; move to an env var when you set up environments.
const AMPLITUDE_API_KEY = '73a1434fe7bc99d184166f005a43b1e0';

amplitude.initAll(AMPLITUDE_API_KEY, {"analytics":{"autocapture":true},"sessionReplay":{"sampleRate":1}});
