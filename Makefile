SHELL = /bin/bash
LINK_FLAGS = --link-flags "-static" -D without_openssl
PROG = squid-cache

.PHONY : all static dynamic compile spec clean bin test
.PHONY : ${PROG}

all: static

test: spec compile static version

static: src/bin/main.cr
	crystal build --release $^ -o ${PROG} ${LINK_FLAGS}

dynamic: src/bin/main.cr
	crystal build $^ -o ${PROG} ${LINK_FLAGS}

spec:
	crystal spec -v --fail-fast

compile:
	@for x in src/bin/*.cr ; do\
	  crystal build "$$x" -o /dev/null ;\
	done

clean:
	@rm -rf squid-cache

version:
	./squid-cache --version
