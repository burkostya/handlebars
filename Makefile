version = `grep -o 'version.*' ../component.json | awk '{split($$0,a,"\""); print a[3];}'`

component:
	@rm -rf handlebars.js
	@git clone https://github.com/wycats/handlebars.js.git
	@cd handlebars.js && git checkout $(version)
	@cd handlebars.js && bundle install && rake release
	@cp handlebars.js/dist/handlebars.js ./index.js
	@rm -rf handlebars.js
	@sed -i '/this.Handlebars = {};/ a \
		module.exports = this.Handlebars;' index.js

build: components index.js
	@component build --dev

components: component.json
	@component install --dev

clean:
	rm -fr build components template.js

.PHONY: clean
