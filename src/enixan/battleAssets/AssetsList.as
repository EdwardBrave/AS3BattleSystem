package enixan.battleAssets {
    import enixan.battleSystemCore.Component;
    import enixan.battleSystemCore.Entity;

    import flash.utils.getDefinitionByName;

    /**The list of entities, components and behaviour that can be added to the battle logic*/
    public class AssetsList {

        /**
         * Search the class by name from the list of classes
         * @param className the name of the class that will be searching
         * @return prototype of the found class
         * */
        public static function getClassByName(className:String):Class {
            try{
                if (className == "Entity"){
                    return Entity;
                } else if(className == "Component"){
                    return Component;
                } else {
                    return getDefinitionByName("enixan.battleAssets." + className) as Class;
                }
            }
            catch (err:Error){
                trace("#>>enixan.battleAssets.AssetsList::getClassByName:22");
                trace("#>>AssetsError! Class of the given name \""+className+"\" not found.");
            }
            return null;
        }

        //LIST_OF_ASSETS________________________________________________________________________________________________
            //NOTE: Put your class name here for add it to search list of function getDefinitionByName()

        //END-----------------------------------------------------------------------------------------------------------
    }
}
