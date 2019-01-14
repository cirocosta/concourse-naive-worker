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

