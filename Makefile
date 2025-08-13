all:
	$(MAKE) clean
	$(MAKE) release

release:
	cmake -S . -B ./build
	cmake --build ./build

debug:
	cmake -DCMAKE_BUILD_TYPE:STRING=Debug -S . -B ./build
	cmake --build ./build

install:
	cmake --install ./build

clean:
	rm -rf build/
	rm -rf src/gresource.c
