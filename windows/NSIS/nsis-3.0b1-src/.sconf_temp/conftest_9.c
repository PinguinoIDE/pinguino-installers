
		int main() {
			#ifdef __BIG_ENDIAN__
				// already defined, no need to define again
				return 0;
			#else
				int i = 1;
				char *c = (char *) &i;
				return c[0] != 1;
			#endif
		}
	