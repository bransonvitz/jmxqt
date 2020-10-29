// Copyright (c) 2020 All Rights Reserved
// Contact information for this software is available at:
// https://github.com/bransonvitz/jmxqt
//
// This file is part of jmxqt.
//
// jmxqt is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation, either version 3 of
// the License, or (at your option) any later version.
//
// jmxqt is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the
// GNU Lesser General Public License along with jmxqt.
// If not, see <http://www.gnu.org/licenses/>.
package org.apache.jmeter.plugin;

import java.io.File;
 
import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.awt.event.ActionEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.apache.jmeter.exceptions.IllegalUserActionException;
import org.apache.jmeter.gui.action.AbstractAction;
import org.apache.jmeter.gui.GuiPackage;

public class LocalXQT extends AbstractAction {

	private static final Logger pLog = LoggerFactory.getLogger(LocalXQT.class);
	private static final Set<String> pCmds = new HashSet<>();

	static {
		pCmds.add("ACTION_XQT");
	}

	public LocalXQT() {
		String sOS = System.getProperty("os.name");
		bPOSIX = sOS.startsWith("Windows") ? false : true;
		sHome = System.getProperty("user.home");
		pLog.debug("OS Name: "+sOS+", Home: "+sHome);
		return;
	}

	public Set<String> getActionNames() {
		return( pCmds);
	}

	@Override
	public void doAction( ActionEvent pEvt) throws IllegalUserActionException {
		String sPathJMX = GuiPackage.getInstance().getTestPlanFile();
		pLog.debug( "Path to JMX: "+sPathJMX);
		if ( pEvt != null && sPathJMX != null && !sPathJMX.equals("null")) {
			sJMX = sPathJMX.substring(sPathJMX.lastIndexOf(File.separator)+1);
			pLog.debug( "JMX file name: "+sJMX);
			if ( pEvt.getActionCommand().equals("ACTION_XQT")) {
				try {
					String sExe = bPOSIX ? sHome+"/bin/jmxqtctl" : sHome+"/bin/jmxqtctl.bat";
					ProcessBuilder pb = new ProcessBuilder( sExe, sJMX);
					Map<String, String> env = pb.environment();
					Process p = pb.start();
				} catch ( Exception pE) { pLog.error("stack trace:\n",pE); }
			}
		} else throw new IllegalUserActionException("XQT with JMX: "+sPathJMX);
		return;
	}

	private boolean bPOSIX;
	private String sHome;
	private String sJMX;
}
