NAME                ?= $(shell uuidgen | cut -d '-' -f1)
TSA_ADDRESS         ?= localhost:2222
TSA_PUBLIC_KEY		?= ./keys/tsa_host_key.pub
WORKER_PRIVATE_KEY  ?= ./keys/worker_key
WORKER_STATE_DIR    ?= ./workers/$(NAME)


define HELP
USAGE
    make (run|clean|help)


COMMANDS
    run     Runs a concourse worker using `houdini` as its garden
            implementation, and `naive` as its baggageclaim driver.

            The worker is supposed to register against a Concourse
            instance with TSA exposed at `TSA_ADDRESS`, with the
            TSA's public key configured at `TSA_PUBLIC_KEY`, and
            the worker's private key at `WORKER_PRIVATE_KEY`.

            By default, it assumes a local Concourse running TSA
            at `localhost:2222` with the keys existing in the web
            Docker container.


    clean   Cleans any artifacts produced by this file.


ENVIRONMENT VARIABLES

    NAME    Configures the name of the worker to register against
            the concourse instance.

            The configured name is also used as the name for the
            directory to hold worker data under the `./workers`
            directory.

endef


run: $(WORKER_PRIVATE_KEY) $(TSA_PUBLIC_KEY)
	concourse worker \
		--name=$(NAME) \
		--tsa-host=$(TSA_ADDRESS) \
		--tsa-worker-private-key=$(WORKER_PRIVATE_KEY) \
		--tsa-public-key=$(TSA_PUBLIC_KEY) \
		--work-dir=$(WORKER_STATE_DIR)


clean:
	find ./keys -type f -mindepth 1 -maxdepth 1 -delete
	find ./workers -type d -mindepth 1 -maxdepth 1 -exec rm -rf '{}' +



$(TSA_PUBLIC_KEY):
	docker cp \
		concourse_web_1:/concourse-keys/tsa_host_key.pub \
		$@

$(WORKER_PRIVATE_KEY):
	docker cp \
		concourse_web_1:/concourse-keys/worker_key \
		$@


export HELP
help:
	@echo "$$HELP"
