NVIM                ?= nvim
PROFILE_FILE        ?= .startuptime
PROFILE_ARGS        ?= --headless +q
PROFILE_CMD         := $(NVIM) $(PROFILE_ARGS) --startuptime $(PROFILE_FILE)
PROFILE_TIMEOUT_SEC ?= 5

.PHONY: profile

profile:
	@echo "Profiling Neovim startup"
	@$(PROFILE_CMD) &
	@NVIM_PID=$$!; \
	echo "Waiting $(PROFILE_TIMEOUT_SEC)s..." \
	sleep $(PROFILE_TIMEOUT_SEC) \
	kill $$NVIM_PID 2>/dev/null || true
	@cat .startuptime

.PHONY: clean

clean:
	@rm $(PROFILE_FILE)

.PHONY: fmt

fmt:
	@stylua **/*/*.lua
