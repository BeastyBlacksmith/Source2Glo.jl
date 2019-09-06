# Source2Glo

<!-- [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://beastyblacksmith.github.io/Source2Glo.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://beastyblacksmith.github.io/Source2Glo.jl/dev) -->
[![Build Status](https://travis-ci.com/beastyblacksmith/Source2Glo.jl.svg?branch=master)](https://travis-ci.com/beastyblacksmith/Source2Glo.jl)
[![Codecov](https://codecov.io/gh/beastyblacksmith/Source2Glo.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/beastyblacksmith/Source2Glo.jl)

Extracts TODOs from all registered paths and manages a Glo-board accordingly.

Connect to you Glo-boards by creating a [PAT](https://app.gitkraken.com/pat/new).

Your token will be encrypted before storage, but be aware that the default key is (at the moment) public.
It can be changed via setting `Source2Glo.key[]`.

Register your projects via `Source2Glo.register("path/to/project")`.

Source2Glo will create a board named `.~*~. todo-Source2Glo .~*~.` and create columns for each project and cards for each TODO found.

Updates your Glo-board has three modes
 - automatically when exiting julia with `Source2Glo.configuration["update-mode"] = "at-exit"`
 - automatically when loading Source2Glo with `Source2Glo.configuration["update-mode"] = "at-start"`
 - trigger it manually with `Source2Glo.update_board()`.

Once configured, all you need to do is put `using Source2Glo` in `~/.julia/config/startup.jl` and your TODOs will always be synced.
