package enixan.battleSystemCore{
    import com.greensock.TweenLite;
    import flash.system.System;

import hlp.List;

    /**
     * Global static class that control`s updates and manage active processes in game session
     * */
    public class UpdateManager { 

        /** Vector of functions that reacts on **tween update** */
        public static var onUpdateList:Vector.<Function> = new Vector.<Function>();

        /** Vector of functions that reacts on **battle update** */
        public static var onStartList:Vector.<Function> = new Vector.<Function>();

        /** Sorted list of priority processes that reacts on **tween update** */
        public static var processList:List = new List();

        /** TweenLite object allows to manage battle session and generate events *(updates)**/
        private static var _tween:TweenLite;

        /** Gives some interface for control current battle session */
        public static function get tween():TweenLite {
            return _tween;
        }

        /** Stored information about length of current session and other time settings
         * ***Object:{time: Number , prevTime: Number}***
         * **time** - elapsed time from start of battle session to current update
         * **prevTime** - elapsed time from start of battle session to previous update
         * */
        private static var _timeData:Object;

        /**
         * @return elapsed time from start of battle session to current update
         * */
        public static function get elapsedTime():Number{
            return _timeData.time;
        }

        /**
         * Delta value between  time and prevTime
         * **time** - elapsed time from start of battle session to current update
         * **prevTime** - elapsed time from start of battle session to previous update
         * @return elapsed time for the last update step
         * */
        public static function get deltaTime():Number{
            return _timeData.time - _timeData.prevTime;
        }

        /**
         * Initialise variables and start battle session by TweenLite
         * */
        public static function initUpdate():void {
            if (tween) {
                tween.kill();
            }
            if(!_timeData){
                _timeData = {};
            }
            _timeData.time = _timeData.prevTime = 0.0;
            _tween = TweenLite.to( _timeData, int.MAX_VALUE,{time: int.MAX_VALUE, onUpdate: _onUpdate} );
        }

        /**
         * Reinitialize tween *(for start real battle session)* and dispatch the start battle event
         * */
        public static function startBattle():void {
            initUpdate();
            for each(var func:Function in onStartList){
                func.call();
            }
        }

        /**
         * Update of all functions that contains in **onUpdateList** and prevTime of current update
         * */
        private static function _onUpdate():void {
            for each(var func:Function in onUpdateList){
                func.call();
            }
            processList.forEach(_onProcessesUpdate);
            _timeData.prevTime = _timeData.time;
        }

        /**
         * Update of all processes from **processList**
         * */
        private static function _onProcessesUpdate(process:Object):void {
            if (!(process is Process))
                return;
            (process as Process).update();
        }

        /**
         * Stop tween updates and clear all variables *(start ***garbage collector***)*
         * */
        public static function clear():void {
            tween.kill();
            onUpdateList.splice(0,onUpdateList.length);
            onStartList.splice(0,onStartList.length);
            processList.clear();
            System.gc();
        }
    }
}
