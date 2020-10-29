# Copyright (c) 2020 All Rights Reserved
# Contact information for this software is available at:
# https://github.com/bransonvitz/jmxqt
#
# This file is part of jmxqt.
#
# jmxqt is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# jmxqt is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the
# GNU Lesser General Public License along with jmxqt.
# If not, see <http://www.gnu.org/licenses/>.
JAR = AA-xqt.jar
JMH = $(HOME)/jmeter
CP1 = "$(JMH)/lib/jorphan.jar:$(JMH)/lib/slf4j-api-1.7.30.jar:$(JMH)/lib/ext/ApacheJMeter_core.jar:$(JMH)/lib/ext/ApacheJMeter_components.jar:."

JSD = org/apache/jmeter/plugin
J_SRC = $(JSD)/LocalXQT.java

all: $(JAR)
	@echo Build complete

clean:
	@rm -f $(JAR) $(JSD)/*.class

sync: $(JAR)
	@rsync -ai $(JAR) $(JMH)/lib/ext/

$(JAR): LCP=$(CP1)
$(JAR): $(J_SRC:.java=.class)
	jar cf $(JAR) $(JSD)/*.class org/apache/jmeter

%.class : %.java
	javac -cp $(LCP) $<
