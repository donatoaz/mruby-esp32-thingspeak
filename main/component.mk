COMPONENT_DEPENDS = mruby_component

COMPONENT_EXTRA_CLEAN := example_mrb.h

mruby_main.o: example_mrb.h

example_mrb.h: $(COMPONENT_PATH)/thingspeak_temperature.rb
	$(COMPONENT_PATH)/../components/mruby_component/mruby/bin/mrbc -B example_mrb -o $@ $^

.PHONY: example_mrb.h
