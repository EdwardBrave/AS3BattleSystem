package enixan.battleSystemCore {
    import enixan.battleAssets.AssetsList;

    /**
     * This class construct and manage entities that can be used in battle system core (ECS)
     * @author EdwardBrave
     * */
    public class EntityBuilder {

        /**
         * Build new Entity and connect other components and entities to it for making specific asked functionality
         * @param buildData *(EntityVO)* prototype of entity and it components. Using this settings will be created new Entity
         *
         * struct: *(EntityVO) { className:(String), settings:(Object), children:(Vector.<EntityVO>[...]) }*
         *
         * @return pointer on new Entity with intialised tree of connected **Behaviours**, **Components** and other **Entities**
         * */
        public static function buildEntity(buildData:EntityVO):IComponent {
            var assetClass:Class = AssetsList.getClassByName(buildData.className);
            var component:IComponent;
            try {
                component = new assetClass();
            }
            catch(err:Error){
                trace("#>>enixan.battleSystemCore.EntityBuilder::buildEntity:10");
                if (assetClass == null) {
                    trace("#>>BuildError! Class type of \"" + buildData.className + "\" is null! Operation denied.");
                    return null;
                } else if (err.errorID == 1034){
                    trace("#>>BuildError! Class type of \"" + buildData.className + "\" dont implements IComponent! Operation denied.");
                    return null;
                }
                throw err;
            }
            component.init(buildData.settings);
            if (component is Container) {
                if (buildData.children) {
                    for each(var item:EntityVO in buildData.children) {
                        (component as Container).addComponent(buildEntity(item));
                    }
                }
                if (component is Entity && buildData.behaviourVO) {
                    var behaviourManager:IBehaviourManager;
                    assetClass = AssetsList.getClassByName("behaviour." + buildData.behaviourVO.className);
                    try {
                        behaviourManager = new assetClass(buildData.behaviourVO);
                    }
                    catch (err:Error) {
                        trace("#>>enixan.battleSystemCore.EntityBuilder::buildEntity:32");
                        if (assetClass == null) {
                            trace("#>>BuildError! Behaviour class type of \"" + buildData.behaviourVO.className + "\" is null! Operation denied.");
                            return component;
                        } else if (err.errorID == 1034) {
                            trace("#>>BuildError! Behaviour class type of \"" + buildData.behaviourVO.className + "\" dont implements IBehaviourManager! Operation denied.");
                            return component;
                        }
                        throw err;
                    }
                    (component as Entity).behaviourManager = behaviourManager;
                }
            }
            return component;
        }
    }
}
