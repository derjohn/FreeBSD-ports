# $FreeBSD$

PORTNAME=	libcouchbase
DISTVERSION=	2.7.2
CATEGORIES=	databases
MASTER_SITES=	http://packages.couchbase.com/clients/c/

MAINTAINER=	sergey@couchbase.com
COMMENT=	Multithreaded noSQL database (client and library)

LICENSE=	APACHE20

LIB_DEPENDS=	libevent.so:devel/libevent \
		libev.so:devel/libev \
		libuv.so:devel/libuv

CMAKE_ARGS+=	-DLCB_NO_TESTS=1

USES=		cmake perl5 ssl
USE_LDCONFIG=	yes
USE_PERL5=	build run

MAKE_JOBS_UNSAFE=	yes

BROKEN_aarch64=		Fails to link: error adding symbols: File in wrong format
BROKEN_mips64=		Fails to link: ld: failed to merge target specific data

.include <bsd.port.mk>
