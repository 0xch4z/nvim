NVIM                ?= nvim
BENCH_RUNS          ?= 10
BENCH_WARMUP        ?= 3
BENCH_FILE          ?= .benchmark.csv
PROFILE_FILE        ?= .startuptime.log
PROFILE_FILE_HEADER ?= \# Generated at $$(date +%s) ($$(git rev-parse --short HEAD))
PROFILE_ARGS        ?= --headless +qa
PROFILE_START_CMD   := $(NVIM) $(PROFILE_ARGS) --startuptime $(PROFILE_FILE)
PROFILE_TIMEOUT_SEC ?= 5

.PHONY: profile

profile:
	@echo "Profiling Neovim startup"
	@$(PROFILE_START_CMD) &
	@NVIM_PID=$$!; \
		echo "Waiting $(PROFILE_TIMEOUT_SEC)s..." \
		sleep $(PROFILE_TIMEOUT_SEC) \
		kill $$NVIM_PID 2>/dev/null || true
	@printf '%s\n%s\n' "$(PROFILE_FILE_HEADER)" "$$(cat $(PROFILE_FILE))" > $(PROFILE_FILE)
	@cat $(PROFILE_FILE)

.PHONY: benchmark

benchmark:
	@echo "Benchmarking Neovim startup"
	@hyperfine "$(NVIM) $(PROFILE_ARGS)" --warmup $(BENCH_WARMUP) -r $(BENCH_RUNS) --export-csv $(BENCH_FILE)
	@printf '%s\n%s\n' "$(PROFILE_FILE_HEADER)" "$$(cat $(BENCH_FILE))" > $(BENCH_FILE)
	@cat $(BENCH_FILE)

.PHONY: clean

clean:
	@rm $(PROFILE_FILE) $(BENCH_FILE)

.PHONY: fmt

fmt:
	@stylua **/*/*.lua
