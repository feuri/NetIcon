SRC = src/main.vala src/trayicon.vala src/netmonitor.vala src/confighandler.vala

OUTPUT = neticon

PKGS = --pkg gtk+-3.0 --pkg gio-2.0

VALAC = valac

VALACOPTS = -g

DESTDIR =

# implementation

neticon:
	$(VALAC) $(SRC) $(VALACOPTS) $(PKGS) -o $(OUTPUT)

all:
	make neticon
	
clean:
	rm -vfr *~ $(OUTPUT)

install:
	install -d $(DESTDIR)usr/bin/
	install -m755 $(OUTPUT) $(DESTDIR)usr/bin/
	install -d $(DESTDIR)usr/share/licenses/$(OUTPUT)/
	install -m644 LICENSE $(DESTDIR)usr/share/licenses/$(OUTPUT)/
