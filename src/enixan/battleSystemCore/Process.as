package enixan.battleSystemCore {

    /**
     * It has an information about current process: its length, state, progress, connected component... ,
     * react on events and start reactions in component
     * */
    public class Process {

        /**Event for the process event dispatcher*/
        public static const START:uint = 0;
        /**Event for the process event dispatcher*/
        public static const PAUSE:uint = 1;
        /**Event for the process event dispatcher*/
        public static const RESET:uint = 2;
        /**Event for the process event dispatcher*/
        public static const KILL:uint = 3;
        /**Event for the process event dispatcher*/
        public static const UPDATE:uint = 4;
        /**Event for the process event dispatcher*/
        public static const COMPLETE:uint = 5;

        /**
         * Vector of functions-listeners that react on events
         * Events:
         *      START, PAUSE, RESET, KILL, UPDATE, COMPLETE
         * */
        public var listeners:Vector.<Function>;

        /**Time length of the process in seconds*/
        private var _length:Number;

        /**Elapsed time length of the process in seconds*/
        private var _elapsedTime:Number;

        /**Priority of the process for the global queue of update*/
        private var _priority:uint;

        /**
         * Give the progress of current process
         * */
        public function get progress():Number {
            return (_elapsedTime / _length) || 0;
        }

        /**
         * Give the elapsed time of current process
         * */
        public function get elapsedTime():Number {
            return _elapsedTime;
        }

        /**
         * Check current activity of process
         * return **true** if process is contains in global update queue
         * */
        public function get isActive():Boolean {
            var vector:Vector.<Object> = UpdateManager.processList.getVector(_priority);
            if(vector) {
                return  vector.indexOf(this) != -1;
            }
            return false;
        }

        /**
         * Check progress and finishing of process *(dont check an activity of process)*
         * return **true** if process finished
         * */
        public function get isFinished():Boolean {
            return _elapsedTime >= _length;
        }

        /**
         * Give delta time regarding progress of current process
         * return elapsed time for the last process update step
         * */
        public function get deltaProcTime():Number {
            if (_length - _elapsedTime < UpdateManager.deltaTime) {
                return _length - _elapsedTime;
            }else{
                return UpdateManager.deltaTime;
            }
        }

        /**
         * Initialize new process, it event dispatcher and priority in global update queue
         * @param priority Value of place in global update queue
         * */
        public function Process(priority:uint) {
            _priority = priority;
            listeners = new Vector.<Function>(6,true);
        }

        /**
         * Call function-listener of given event
         * @param event that will be dispatched
         * */
        private function dispatchEvent(event:uint):void {
            if (0 <= event && event < listeners.length  && listeners[event]) {
                listeners[event].call();
            }
        }

        /**
         * Start *(or continue)* the process and change basic settings of it
         * @param newProgress *(from 0.0 to 1.0)* process completion percentage *(if -1 then value will not be changed)*
         * @param length *(time in seconds)* time for process completion *(if -1 then value will not be changed)*
         * */
        public function start(newProgress:Number = -1, length:Number = -1):void {
            var currentProgress:Number = progress;
            _length = (length < 0)? _length : length;
            _elapsedTime = ((newProgress < 0) ? currentProgress: newProgress) * _length;
            UpdateManager.processList.push(_priority, this);
            dispatchEvent(START);
        }

        /**
         * Pause processing updates
         * */
        public function pause():void {
            UpdateManager.processList.removeItemAt(_priority, this);
            dispatchEvent(PAUSE);
        }

        /**
         * Internal update function that reacts on global update event
         * */
        internal function update():void {
            _elapsedTime += deltaProcTime;
            if(isFinished) {
                UpdateManager.processList.removeItemAt(_priority, this);
                dispatchEvent(COMPLETE);
                return;
            }
            dispatchEvent(UPDATE);
        }

        /**
         * Change basic settings of the process *(function will not stop updates of it)*
         * @param newProgress *(from 0.0 to 1.0)* process completion percentage *(if -1 then value will not be changed)*
         * @param length *(time in seconds)* time for process completion *(if -1 then value will not be changed)*
         * */
        public function reset(newProgress:Number = 0.0, length:Number = -1):void {
            var currentProgress:Number = progress;
            _length = (length < 0)? _length : length;
            _elapsedTime = ((newProgress < 0) ? currentProgress: newProgress) * _length;
            dispatchEvent(RESET);
        }

        /**
         * Remove the **Process** and all information about it
         * **CAUTION!** After this action the **Process** will be dead and unusable
         * */
        public function kill():void {
            UpdateManager.processList.removeItemAt(_priority, this);
            dispatchEvent(KILL);
            listeners = null;
        }
    }
}
