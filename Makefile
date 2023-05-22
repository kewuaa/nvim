install: bin ./cpp/imtoggle.cpp
	${CXX} -o ./bin/imtoggle.exe -limm32 ./cpp/imtoggle.cpp

./bin:
	mkdir bin
