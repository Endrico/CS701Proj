package systemj.signals.jop;
import java.util.Vector;
import java.util.Hashtable;

import com.jopdesign.io.LedSwitch;
import com.jopdesign.io.LedSwitchFactory;

import systemj.interfaces.GenericSignalReceiver;
public class SignalSW extends GenericSignalReceiver{
	
	private LedSwitch ls = LedSwitchFactory.getLedSwitchFactory().getLedSwitch();
	
	// Mask used to determine which SW is used for this instance
	private int SW_MASK;

	/**
	 * This method is used internally which returns SystemJ signal implemented in Java object.
	 */
	@Override
	public synchronized void getBuffer(Object[] obj) {
		if ((ls.ledSwitch & SW_MASK) == 0)
			obj[0] = Boolean.FALSE;
		else
			obj[0] = Boolean.TRUE;
	}

	/**
	 * Method which initialize this receiver instance
	 * @param data Hashtable object which contains parsed data from XML
	 * @throws RuntimeException - When there is an error occured during configuration
	 */
	@Override
	public void configure(Hashtable data) throws RuntimeException {
		if(data.containsKey("Index")){
			SW_MASK =  Integer.valueOf(((String)data.get("Index"))).intValue();
		}
		else
			throw new RuntimeException("Index not specified in XML");
	}
	/**
	 * Since getting a status from switch is non-blocking, this method is not needed. </br>
	 * Instead write user-defined code in getBuffer()
	 * @author Heejong Park
	 */
	@Override
	public void run() {

	}
	
	public SignalSW(){
		super();
	}

}
