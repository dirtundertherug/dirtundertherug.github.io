INDEXREDIRECT=toc
.include "dirty.mk"

all: toc.html index.html

toc.md: toc.md.in
	cp ${.CURDIR}/toc.md.in $@
	(cd ${.CURDIR} && find * -type f -name '*.md' | sort -sr) \
		| sed -r -e 's/\.md$$/.html/' \
		| while read n; do echo "  * [$$n]($$n)" >> $@; done

SUBDIR=0000 \
	2026

.include <bsd.subdir.mk>
