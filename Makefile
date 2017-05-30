spec:
	busted .

lint:
	luacheck src

.PHONY: lint spec
