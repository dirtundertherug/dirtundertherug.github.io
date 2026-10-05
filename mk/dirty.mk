LOWDOWN_FLAGS=-s \
	-thtml \
	--parse-hilite \
	--parse-math \
	--parse-no-autolink \
	--out-no-smarty \
	--html-callout-mdn --html-callout-gfm \
	--parse-no-codeindent \
	--html-custom-attributes \
	--html-no-num-ent \
	--html-no-escapehtml \
	--html-no-owasp \
	--html-no-skiphtml

DUTR=${HOME}/dutr
ABSWWW=${DUTR}/www
ABSETC=${ABSWWW}/etc
DIRTY_TEMPLATE=${DUTR}/.obj/dirty.html
IMPUREASC=${ABSETC}/dirty-impurify.asc

.BEGIN:
	test -d ${.CURDIR:S,^${DUTR}/src,${DUTR}/www,} || mkdir -p ${.CURDIR:S,^${DUTR}/src,${DUTR}/www,}

.OBJDIR: ${.CURDIR:S,^${DUTR}/src,${DUTR}/www,}

ARTICLE_TEMPLATE=${DUTR}/templates/dirty.html.head \
	${DUTR}/templates/dirty.html.article \
	${DUTR}/templates/dirty.html.foot

${DUTR}/.obj/dirty.html: ${ARTICLE_TEMPLATE}
	test -d ${DUTR}/.obj || mkdir -p ${DUTR}/.obj
	cat ${ARTICLE_TEMPLATE} > $@

.SUFFIXES: .md .html
.md.html: ${DIRTY_TEMPLATE}
	lowdown ${LOWDOWN_FLAGS} \
		-m "css=`realpath --relative-to=. ${ABSETC}/dutr.css`  `realpath --relative-to=. ${ABSETC}/katex/katex.min.css`" \
		-m "icon=`realpath --relative-to=. ${ABSETC}/scarlet-prohibition.svg`" \
		-m "pgpfile=`realpath --relative-to=. ${IMPUREASC}`" \
		-m "aboutmeurl=`realpath --relative-to=. ${ABSWWW}/about/impurify.html`" \
		-m "lawyeradurl=`realpath --relative-to=. ${ABSWWW}/personals/first-amendment-lawyers-scholars.html`" \
		-m "thoughtfuladurl=`realpath --relative-to=. ${ABSWWW}/personals/the-thoughtful-people.html`" \
		--template ${DIRTY_TEMPLATE} \
		$< \
		| \
	sed -r -e 's/<!--#([^#]*)#-->/<\1>/g' | \
	katex > $@

# Usage note: Don’t forget to set this variable *before* .including "dirty.mk".
.ifdef INDEXREDIRECT
index.html: ${DUTR}/src/redirect-index.html
	sed -r -e "s/@/${INDEXREDIRECT}/g" < \
		${DUTR}/src/redirect-index.html \
		> $@
.endif
