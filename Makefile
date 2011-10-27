SRC = src/main.vala src/trayicon.vala src/netmonitor.vala

OUTPUT = neticon

PKGS = --pkg gtk+-3.0 --pkg gio-2.0

VALAC = valac

VALACOPTS = -g

# implementation

neticon:
	$(VALAC) $(SRC) $(VALACOPTS) $(PKGS) -o $(OUTPUT)

all:
	make neticon
	
clean:
	rm -vfr *~ $(OUTPUT)
