# $FreeBSD$

PORTNAME=	Git-Sub
PORTVERSION=	0.163320
CATEGORIES=	devel perl5
MASTER_SITES=	CPAN
PKGNAMEPREFIX=	p5-

MAINTAINER=	perl@FreeBSD.org
COMMENT=	Git commands imported into the git:: namespace

LICENSE=	ART10 GPLv1
LICENSE_COMB=	dual
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS:=	p5-File-Which>=0:sysutils/p5-File-Which \
		p5-System-Sub>=0:devel/p5-System-Sub
RUN_DEPENDS:=	${BUILD_DEPENDS}

NO_ARCH=	yes
USES=		perl5
USE_PERL5=	configure

.include <bsd.port.mk>
