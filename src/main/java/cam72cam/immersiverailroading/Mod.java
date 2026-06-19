package cam72cam.immersiverailroading;

import cam72cam.mod.ModCore;
import net.neoforged.bus.api.SubscribeEvent;

@net.neoforged.fml.common.Mod(Mod.MODID)
public class Mod {
    public static final String MODID = "immersiverailroading";

    static {
        try {
            ModCore.register(new cam72cam.immersiverailroading.ImmersiveRailroading());
        } catch (Exception e) {
            throw new RuntimeException("Could not load mod " + MODID, e);
        }
    }
}
