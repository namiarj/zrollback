OS=					$$(uname -o)
ARCH=				$$(if [ "$$(uname -m)" = "x86_64" ]; then echo amd64; else uname -m; fi;)
DEBUG=				$$(if [ "${OS}" = "FreeBSD" ]; then echo set -xeouv pipefail; else echo set -xeouv; fi)

ZFSCTL_VERSION=		$$(git rev-parse HEAD)
ZFSCTL_CMD	=	/usr/local/bin/zrollback

.PHONY: all
all:
	@echo "Nothing to be done. Please use make install or make uninstall"

.PHONY: deps
deps:
	@echo "Install applications"
	@if [ -e /etc/debian_version ]; then\
		DEBIAN_FRONTEND=noninteractive apt install -y zfs-dkms;\
	elif [ "${OS}" = "FreeBSD" ]; then\
		pkg install -y git-lite;\
	fi

.PHONY: man
man:
	@echo "Manual is not exists for zrollback yet."
#	@if [ -f usr/local/share/man/man8/zrollback.8 ]; then\
#		gzip -f usr/local/share/man/man8/zrollback.8;\
#	fi

.PHONY: install
install: deps man
	@echo "Installing zrollback"
	@echo
	@cp -Rv usr /
	@chmod +x ${ZFSCTL_CMD}
	@echo

.PHONY: installonly
installonly: man
	@echo "Installing zrollback"
	@echo
	@cp -R usr /
	@echo "This method is for testing / development."

.PHONY: uninstall
uninstall:
	@echo "Removing zrollback command"
	@rm -vf ${ZFSCTL_CMD}
