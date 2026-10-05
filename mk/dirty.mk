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
DOTOBJ=${DUTR}/.obj
DIRTY_TEMPLATE=${DOTOBJ}/dirty.html
TEMPLATE?=dirty
TEMPLATE:=${DOTOBJ}/${TEMPLATE}.html
IMPUREASC=${ABSETC}/dirty-impurify.asc

.BEGIN:
	test -d ${.CURDIR:S,^${DUTR}/src,${DUTR}/www,} || mkdir -p ${.CURDIR:S,^${DUTR}/src,${DUTR}/www,}

.OBJDIR: ${.CURDIR:S,^${DUTR}/src,${DUTR}/www,}

${DOTOBJ}:
	test -d ${DOTOBJ} || mkdir -p ${DOTOBJ}

THEAD=${DUTR}/templates/dirty.html.head
TFOOT=${DUTR}/templates/dirty.html.foot

DIRTY_TEMPLATE_SRCS=${THEAD} \
	${DUTR}/templates/dirty.html.article \
	${TFOOT}

${DIRTY_TEMPLATE}: ${DIRTY_TEMPLATE_SRCS} ${DOTOBJ}
	cat ${DIRTY_TEMPLATE_SRCS} > $@

.SUFFIXES: .md .html
.md.html: ${TEMPLATE}
	lowdown ${LOWDOWN_FLAGS} \
		-m "css=`realpath --relative-to=. ${ABSETC}/dutr.css`  `realpath --relative-to=. ${ABSETC}/katex/katex.min.css`" \
		-m "icon=`realpath --relative-to=. ${ABSETC}/scarlet-prohibition.svg`" \
		-m "pgpfile=`realpath --relative-to=. ${IMPUREASC}`" \
		-m "aboutmeurl=`realpath --relative-to=. ${ABSWWW}/about/impurify.html`" \
		-m "lawyeradurl=`realpath --relative-to=. ${ABSWWW}/personals/first-amendment-lawyers-scholars.html`" \
		-m "thoughtfuladurl=`realpath --relative-to=. ${ABSWWW}/personals/the-thoughtful-people.html`" \
		--template ${TEMPLATE} \
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
