obj = $(wildcard kernel/*.o drivers/*.o *.o boot/*.o kernel/*.img boot/*.bin boot/*.img)

clean: ${obj}
	rm $^
