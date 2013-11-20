#Makefile tester for fsys

#Targets
#    test


AD = admin
CD = client
SD = server

ADMINMODS = generate parse
CLIENTMODS = parseClientRequest response send
SERVERMODS = parse reply retrieveFile saveFile storage user

test: adminMod clientMod serverMod adminTest clientTest

adminMod:
	for m in $(ADMINMODS); do \
		( cd $(AD); cd $$m; echo $$m; \
		make ) \
	done

clientMod:
	for m in $(CLIENTMODS); do \
		( cd $(CD); cd $$m; echo $$m; \
		make ) \
	done

serverMod:
	for m in $(SERVERMODS); do \
		( cd $(SD); cd $$m; echo $$m; \
		make ) \
	done

adminTest:
	(cd $(AD)/.test; mkdir tact; ./test.csh; rm -rf tact;)

clientTest:
	(cd $(CD)/.test; mkdir tact; ./test.csh; rm -rf tact;)
