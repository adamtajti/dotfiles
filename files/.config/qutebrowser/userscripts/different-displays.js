#!/usr/bin/env node

// This was just an experiment. To make it an actually useful script, I would need autocommand
// support for qutebrowser, which is currently not implemented.
// And honestly, I would need an actual scaling functionality from sway itself. That would
// eliminate the need for adjusting zoom levels based on the active display.

const zoomLevel = 400;

const fs = require("fs");
const wstream = fs.createWriteStream(process.env.QUTE_FIFO);
wstream.write(`zoom ${zoomLevel}\n`);
