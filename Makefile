all:
	echo '#!/usr/bin/env node \n' > ./bin/stitchup && coffee -p ./src/stitchup.coffee >> ./bin/stitchup && chmod 755 ./bin/stitchup
