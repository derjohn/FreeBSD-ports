# Created by: Alexey Dokuchaev <danfe@FreeBSD.org>
# $FreeBSD$

PORTNAME=	azpainter
PORTVERSION=	2.0.4
CATEGORIES=	graphics
MASTER_SITES=	http://aarnet.dl.osdn.jp/azpainter/67264/ \
		http://acc.dl.osdn.jp/azpainter/67264/ \
		http://c3sl.dl.osdn.jp/azpainter/67264/ \
		http://cznic.dl.osdn.jp/azpainter/67264/ \
		http://gigenet.dl.osdn.jp/azpainter/67264/ \
		http://iij.dl.osdn.jp/azpainter/67264/ \
		http://jaist.dl.osdn.jp/azpainter/67264/ \
		http://master.dl.osdn.jp/azpainter/67264/ \
		http://nchc.dl.osdn.jp/azpainter/67264/ \
		http://onet.dl.osdn.jp/azpainter/67264/ \
		http://osdn.dl.osdn.jp/azpainter/67264/ \
		http://pumath.dl.osdn.jp/azpainter/67264/ \
		http://rwthaachen.dl.osdn.jp/azpainter/67264/ \
		http://ymu.dl.osdn.jp/azpainter/67264/

MAINTAINER=	danfe@FreeBSD.org
COMMENT=	16-bit RGB full color painting application

LICENSE=	GPLv3

LIB_DEPENDS=	libfontconfig.so:x11-fonts/fontconfig \
		libfreetype.so:print/freetype2 \
		libpng.so:graphics/png

USES=		desktop-file-utils jpeg localbase shared-mime-info tar:bzip2
USE_XORG=	x11 xext xi
GNU_CONFIGURE=	yes
CONFIGURE_ARGS=	--with-freetype-dir=${LOCALBASE}/include/freetype2

PORTDOCS=	AUTHORS ChangeLog NEWS README README.ja manual

OPTIONS_DEFINE=	DOCS NLS
OPTIONS_SUB=	yes

post-patch-NLS-off:
	@${REINPLACE_CMD} -e '/install-dist_trdataDATA$$/d' \
		${WRKSRC}/data/Makefile.in

pre-build-NLS-on:
	cd ${WRKSRC}/translation && ${CC} ${CFLAGS} -o mtrconv mtrconv.c
.for lang in en ru uk
	cd ${WRKSRC}/translation && ./mtrconv ${lang} ../data/tr/${lang}.mtr
.endfor

post-install-DOCS-on:
	@${MKDIR} ${STAGEDIR}${DOCSDIR}
	${CP} -a ${PORTDOCS:S|^|${WRKSRC}/|} ${STAGEDIR}${DOCSDIR}

.include <bsd.port.mk>
