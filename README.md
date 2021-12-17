<p align="center">
<img src="./.github/logo.svg" width="500px" alt="NeoFS">
</p>
<p align="center">
  <a href="https://fs.neo.org">NeoFS</a> Documentation site
</p>

---
![License](https://img.shields.io/github/license/nspcc-dev/doc-fs-neo-org.svg?style=popout)

## Overview

Welcome to the NeoFS Documentation site repository!

This is a [NeoSPCC](https://nspcc.ru/en) maintained and community supported
NeoFS documentation project, where everyone can contribute new articles, suggest
new topics and enhance existing content.

All documentation can be edited via GitHub. We use Hugo for static content
generation, so most of Hugo guides are applicable for this site.

## How to contribute

1. Fork the repo
2. Make some changes
3. Check how it looks localy with `make server`
4. Submit a PR
5. Wait for PR to be merged =)

## Usage

To build and run doc site locally one needs to run `make public`. This `make`
target will download the required version of hugo and use it for site generation.

The resulting static site content will be in the `public` directory.

## License

License: CC BY-NC-SA 4.0

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
