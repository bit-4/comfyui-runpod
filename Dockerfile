# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

# build-time tokens for gated downloads — never baked into final image.
# pass via: docker build --build-arg HF_TOKEN=$HF_TOKEN ...
ARG HF_TOKEN=""

# install custom nodes into comfyui
RUN comfy node install --exit-on-fail derfuu_comfyui_moddednodes --mode remote
RUN comfy node install --exit-on-fail comfyui-impact-pack
RUN comfy node install --exit-on-fail comfyui_ipadapter_plus
RUN comfy node install --exit-on-fail comfyui-advanced-controlnet
RUN comfy node install --exit-on-fail comfyui_controlnet_aux
RUN comfy node install --exit-on-fail cg-use-everywhere
RUN git clone https://github.com/BlenderNeko/ComfyUI_ADV_CLIP_emb /comfyui/custom_nodes/ComfyUI_ADV_CLIP_emb
RUN comfy node install --exit-on-fail was-node-suite-comfyui
RUN git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes /comfyui/custom_nodes/ComfyUI_Comfyroll_CustomNodes
RUN git clone https://github.com/Derfuu/Derfuu_ComfyUI_ModdedNodes /comfyui/custom_nodes/Derfuu_ComfyUI_ModdedNodes
RUN git clone https://github.com/cubiq/ComfyUI_InstantID /comfyui/custom_nodes/ComfyUI_InstantID
RUN git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus /comfyui/custom_nodes/ComfyUI_IPAdapter_plus
RUN git clone https://github.com/mav-rik/facerestore_cf /comfyui/custom_nodes/facerestore_cf
RUN git clone https://github.com/Fannovel16/comfyui_controlnet_aux /comfyui/custom_nodes/comfyui_controlnet_aux
RUN git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet /comfyui/custom_nodes/ComfyUI-Advanced-ControlNet
RUN git clone https://github.com/yolain/ComfyUI-Easy-Use /comfyui/custom_nodes/ComfyUI-Easy-Use
RUN git clone https://github.com/WASasquatch/was-node-suite-comfyui /comfyui/custom_nodes/was-node-suite-comfyui
RUN git clone https://github.com/chrisgoringe/cg-use-everywhere /comfyui/custom_nodes/cg-use-everywhere
RUN git clone https://github.com/AlekPet/ComfyUI_Custom_Nodes_AlekPet /comfyui/custom_nodes/ComfyUI_Custom_Nodes_AlekPet

# download models into comfyui
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/linsg/AWPainting_v1.5.safetensors/resolve/main/AWPainting_v1.5.safetensors' --relative-path models/checkpoints --filename 'AWPainting_v1.5.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors' --relative-path models/controlnet --filename 'control_v11f1p_sd15_depth.pth' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/xingren23/comfyflow-models/resolve/976de8449674de379b02c144d0b3cfa2b61482f2/ckpts/LiheYoung/Depth-Anything/checkpoints/depth_anything_vitl14.pth' --relative-path models/annotators --filename 'depth_anything_vitl14.pth' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do comfy model download --url 'https://cool-anteater-319.convex.cloud/api/storage/1c9112f2-5d61-41d3-a3cb-0057257442e7' --relative-path models/upscale_models --filename 'RealESRGAN_x4plus_anime_6B.pth' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done


# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
