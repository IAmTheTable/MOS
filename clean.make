obj = $(wildcard kernel/*.o drivers/*.o *.o)

clean: ${obj}
	rm $^
