spec:
	busted .

lint:
	luacheck src test

.PHONY: lint spec
