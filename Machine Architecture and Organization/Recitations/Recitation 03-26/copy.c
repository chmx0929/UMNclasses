int copy(int *src, int *dest, int len) {
	
	int result = 0;
	while (len > 0) {
		int val = *src++;
		*dest++ = val;
		result ^= val;
		len--;
	}
	return result;
}



























/* Unrolling by 4 */

int copy(int *src, int *dest, int len) {
	
	int result = 0;

	while (len > 3) {
		int val = *src++;
		*dest++ = val;
		result ^= val;
		
		val = *src++;
		*dest++ = val;
		result ^= val;

		val = *src++;
		*dest++ = val;
		result ^= val;

		val = *src++;
		*dest++ = val;
		result ^= val;

		len -= 4;
	}

	while (len > 0) {
		int val = *src++;
		*dest++ = val;
		result ^= val;
		len--;
	}
	return result;
}




/* Use Jump table for last loop */

int copy(int *src, int *dest, int len) {
	
	int result = 0;

	while (len > 3) {
		int val = *src++;
		*dest++ = val;
		result ^= val;
		
		val = *src++;
		*dest++ = val;
		result ^= val;

		val = *src++;
		*dest++ = val;
		result ^= val;

		val = *src++;
		*dest++ = val;
		result ^= val;

		len -= 4;
	}

	switch (len) {
		case 3:
			int val = *src++;
			*dest++ = val;
			result ^= val;
		case 2:
			int val = *src++;
			*dest++ = val;
			result ^= val;
		case 1:
			int val = *src++;
			*dest++ = val;
			result ^= val;
		default:
			
	}

	return result;
}
