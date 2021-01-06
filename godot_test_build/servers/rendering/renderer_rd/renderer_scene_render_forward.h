/*************************************************************************/
/*  renderer_scene_render_forward.h                                      */
/*************************************************************************/
/*                       This file is part of:                           */
/*                           GODOT ENGINE                                */
/*                      https://godotengine.org                          */
/*************************************************************************/
/* Copyright (c) 2007-2021 Juan Linietsky, Ariel Manzur.                 */
/* Copyright (c) 2014-2021 Godot Engine contributors (cf. AUTHORS.md).   */
/*                                                                       */
/* Permission is hereby granted, free of charge, to any person obtaining */
/* a copy of this software and associated documentation files (the       */
/* "Software"), to deal in the Software without restriction, including   */
/* without limitation the rights to use, copy, modify, merge, publish,   */
/* distribute, sublicense, and/or sell copies of the Software, and to    */
/* permit persons to whom the Software is furnished to do so, subject to */
/* the following conditions:                                             */
/*                                                                       */
/* The above copyright notice and this permission notice shall be        */
/* included in all copies or substantial portions of the Software.       */
/*                                                                       */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,       */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF    */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.*/
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY  */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,  */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE     */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                */
/*************************************************************************/

#ifndef RENDERING_SERVER_SCENE_RENDER_FORWARD_H
#define RENDERING_SERVER_SCENE_RENDER_FORWARD_H

#include "core/templates/paged_allocator.h"
#include "servers/rendering/renderer_rd/pipeline_cache_rd.h"
#include "servers/rendering/renderer_rd/renderer_scene_render_rd.h"
#include "servers/rendering/renderer_rd/renderer_storage_rd.h"
#include "servers/rendering/renderer_rd/shaders/scene_forward.glsl.gen.h"

class RendererSceneRenderForward : public RendererSceneRenderRD {
	enum {
		SCENE_UNIFORM_SET = 0,
		RENDER_PASS_UNIFORM_SET = 1,
		TRANSFORMS_UNIFORM_SET = 2,
		MATERIAL_UNIFORM_SET = 3
	};

	enum {
		SDFGI_MAX_CASCADES = 8,
		MAX_GI_PROBES = 8,
		MAX_LIGHTMAPS = 8,
		MAX_GI_PROBES_PER_INSTANCE = 2,
	};

	/* Scene Shader */

	enum ShaderVersion {
		SHADER_VERSION_DEPTH_PASS,
		SHADER_VERSION_DEPTH_PASS_DP,
		SHADER_VERSION_DEPTH_PASS_WITH_NORMAL_AND_ROUGHNESS,
		SHADER_VERSION_DEPTH_PASS_WITH_NORMAL_AND_ROUGHNESS_AND_GIPROBE,
		SHADER_VERSION_DEPTH_PASS_WITH_MATERIAL,
		SHADER_VERSION_DEPTH_PASS_WITH_SDF,
		SHADER_VERSION_COLOR_PASS,
		SHADER_VERSION_COLOR_PASS_WITH_FORWARD_GI,
		SHADER_VERSION_COLOR_PASS_WITH_SEPARATE_SPECULAR,
		SHADER_VERSION_LIGHTMAP_COLOR_PASS,
		SHADER_VERSION_LIGHTMAP_COLOR_PASS_WITH_SEPARATE_SPECULAR,
		SHADER_VERSION_MAX
	};

	struct {
		SceneForwardShaderRD scene_shader;
		ShaderCompilerRD compiler;
	} shader;

	RendererStorageRD *storage;

	/* Material */

	struct ShaderData : public RendererStorageRD::ShaderData {
		enum BlendMode { //used internally
			BLEND_MODE_MIX,
			BLEND_MODE_ADD,
			BLEND_MODE_SUB,
			BLEND_MODE_MUL,
			BLEND_MODE_ALPHA_TO_COVERAGE
		};

		enum DepthDraw {
			DEPTH_DRAW_DISABLED,
			DEPTH_DRAW_OPAQUE,
			DEPTH_DRAW_ALWAYS
		};

		enum DepthTest {
			DEPTH_TEST_DISABLED,
			DEPTH_TEST_ENABLED
		};

		enum Cull {
			CULL_DISABLED,
			CULL_FRONT,
			CULL_BACK
		};

		enum CullVariant {
			CULL_VARIANT_NORMAL,
			CULL_VARIANT_REVERSED,
			CULL_VARIANT_DOUBLE_SIDED,
			CULL_VARIANT_MAX

		};

		enum AlphaAntiAliasing {
			ALPHA_ANTIALIASING_OFF,
			ALPHA_ANTIALIASING_ALPHA_TO_COVERAGE,
			ALPHA_ANTIALIASING_ALPHA_TO_COVERAGE_AND_TO_ONE
		};

		bool valid;
		RID version;
		uint32_t vertex_input_mask;
		PipelineCacheRD pipelines[CULL_VARIANT_MAX][RS::PRIMITIVE_MAX][SHADER_VERSION_MAX];

		String path;

		Map<StringName, ShaderLanguage::ShaderNode::Uniform> uniforms;
		Vector<ShaderCompilerRD::GeneratedCode::Texture> texture_uniforms;

		Vector<uint32_t> ubo_offsets;
		uint32_t ubo_size;

		String code;
		Map<StringName, RID> default_texture_params;

		DepthDraw depth_draw;
		DepthTest depth_test;

		bool uses_point_size;
		bool uses_alpha;
		bool uses_blend_alpha;
		bool uses_alpha_clip;
		bool uses_depth_pre_pass;
		bool uses_discard;
		bool uses_roughness;
		bool uses_normal;

		bool unshaded;
		bool uses_vertex;
		bool uses_sss;
		bool uses_transmittance;
		bool uses_screen_texture;
		bool uses_depth_texture;
		bool uses_normal_texture;
		bool uses_time;
		bool writes_modelview_or_projection;
		bool uses_world_coordinates;

		uint64_t last_pass = 0;
		uint32_t index = 0;

		virtual void set_code(const String &p_Code);
		virtual void set_default_texture_param(const StringName &p_name, RID p_texture);
		virtual void get_param_list(List<PropertyInfo> *p_param_list) const;
		void get_instance_param_list(List<RendererStorage::InstanceShaderParam> *p_param_list) const;

		virtual bool is_param_texture(const StringName &p_param) const;
		virtual bool is_animated() const;
		virtual bool casts_shadows() const;
		virtual Variant get_default_parameter(const StringName &p_parameter) const;
		virtual RS::ShaderNativeSourceCode get_native_source_code() const;

		ShaderData();
		virtual ~ShaderData();
	};

	RendererStorageRD::ShaderData *_create_shader_func();
	static RendererStorageRD::ShaderData *_create_shader_funcs() {
		return static_cast<RendererSceneRenderForward *>(singleton)->_create_shader_func();
	}

	struct MaterialData : public RendererStorageRD::MaterialData {
		uint64_t last_frame;
		ShaderData *shader_data;
		RID uniform_buffer;
		RID uniform_set;
		Vector<RID> texture_cache;
		Vector<uint8_t> ubo_data;
		uint64_t last_pass = 0;
		uint32_t index = 0;
		RID next_pass;
		uint8_t priority;
		virtual void set_render_priority(int p_priority);
		virtual void set_next_pass(RID p_pass);
		virtual void update_parameters(const Map<StringName, Variant> &p_parameters, bool p_uniform_dirty, bool p_textures_dirty);
		virtual ~MaterialData();
	};

	RendererStorageRD::MaterialData *_create_material_func(ShaderData *p_shader);
	static RendererStorageRD::MaterialData *_create_material_funcs(RendererStorageRD::ShaderData *p_shader) {
		return static_cast<RendererSceneRenderForward *>(singleton)->_create_material_func(static_cast<ShaderData *>(p_shader));
	}

	/* Framebuffer */

	struct RenderBufferDataForward : public RenderBufferData {
		//for rendering, may be MSAAd

		RID color;
		RID depth;
		RID specular;
		RID normal_roughness_buffer;
		RID giprobe_buffer;

		RID ambient_buffer;
		RID reflection_buffer;

		RS::ViewportMSAA msaa;
		RD::TextureSamples texture_samples;

		RID color_msaa;
		RID depth_msaa;
		RID specular_msaa;
		RID normal_roughness_buffer_msaa;
		RID roughness_buffer_msaa;
		RID giprobe_buffer_msaa;

		RID depth_fb;
		RID depth_normal_roughness_fb;
		RID depth_normal_roughness_giprobe_fb;
		RID color_fb;
		RID color_specular_fb;
		RID specular_only_fb;
		int width, height;

		RID render_sdfgi_uniform_set;
		void ensure_specular();
		void ensure_gi();
		void ensure_giprobe();
		void clear();
		virtual void configure(RID p_color_buffer, RID p_depth_buffer, int p_width, int p_height, RS::ViewportMSAA p_msaa);

		~RenderBufferDataForward();
	};

	virtual RenderBufferData *_create_render_buffer_data();
	void _allocate_normal_roughness_texture(RenderBufferDataForward *rb);

	RID shadow_sampler;
	RID render_base_uniform_set;
	RID render_pass_uniform_set;
	RID sdfgi_pass_uniform_set;

	uint64_t lightmap_texture_array_version = 0xFFFFFFFF;

	virtual void _base_uniforms_changed();
	void _render_buffers_clear_uniform_set(RenderBufferDataForward *rb);
	virtual void _render_buffers_uniform_set_changed(RID p_render_buffers);
	virtual RID _render_buffers_get_normal_texture(RID p_render_buffers);
	virtual RID _render_buffers_get_ambient_texture(RID p_render_buffers);
	virtual RID _render_buffers_get_reflection_texture(RID p_render_buffers);

	void _update_render_base_uniform_set();
	RID _setup_sdfgi_render_pass_uniform_set(RID p_albedo_texture, RID p_emission_texture, RID p_emission_aniso_texture, RID p_geom_facing_texture);
	RID _setup_render_pass_uniform_set(RID p_render_buffers, RID p_radiance_texture, RID p_shadow_atlas, RID p_reflection_atlas, const PagedArray<RID> &p_gi_probes, const PagedArray<RID> &p_lightmaps);

	struct LightmapData {
		float normal_xform[12];
	};

	struct LightmapCaptureData {
		float sh[9 * 4];
	};

	enum {
		INSTANCE_DATA_FLAG_USE_GI_BUFFERS = 1 << 6,
		INSTANCE_DATA_FLAG_USE_SDFGI = 1 << 7,
		INSTANCE_DATA_FLAG_USE_LIGHTMAP_CAPTURE = 1 << 8,
		INSTANCE_DATA_FLAG_USE_LIGHTMAP = 1 << 9,
		INSTANCE_DATA_FLAG_USE_SH_LIGHTMAP = 1 << 10,
		INSTANCE_DATA_FLAG_USE_GIPROBE = 1 << 11,
		INSTANCE_DATA_FLAG_MULTIMESH = 1 << 12,
		INSTANCE_DATA_FLAG_MULTIMESH_FORMAT_2D = 1 << 13,
		INSTANCE_DATA_FLAG_MULTIMESH_HAS_COLOR = 1 << 14,
		INSTANCE_DATA_FLAG_MULTIMESH_HAS_CUSTOM_DATA = 1 << 15,
		INSTANCE_DATA_FLAGS_MULTIMESH_STRIDE_SHIFT = 16,
		INSTANCE_DATA_FLAGS_MULTIMESH_STRIDE_MASK = 0x7,
		INSTANCE_DATA_FLAG_SKELETON = 1 << 19,
	};

	struct SceneState {
		struct UBO {
			float projection_matrix[16];
			float inv_projection_matrix[16];

			float camera_matrix[16];
			float inv_camera_matrix[16];

			float viewport_size[2];
			float screen_pixel_size[2];

			float directional_penumbra_shadow_kernel[128]; //32 vec4s
			float directional_soft_shadow_kernel[128];
			float penumbra_shadow_kernel[128];
			float soft_shadow_kernel[128];

			uint32_t directional_penumbra_shadow_samples;
			uint32_t directional_soft_shadow_samples;
			uint32_t penumbra_shadow_samples;
			uint32_t soft_shadow_samples;

			float ambient_light_color_energy[4];

			float ambient_color_sky_mix;
			uint32_t use_ambient_light;
			uint32_t use_ambient_cubemap;
			uint32_t use_reflection_cubemap;

			float radiance_inverse_xform[12];

			float shadow_atlas_pixel_size[2];
			float directional_shadow_pixel_size[2];

			uint32_t directional_light_count;
			float dual_paraboloid_side;
			float z_far;
			float z_near;

			uint32_t ssao_enabled;
			float ssao_light_affect;
			float ssao_ao_affect;
			uint32_t roughness_limiter_enabled;

			float roughness_limiter_amount;
			float roughness_limiter_limit;
			uint32_t roughness_limiter_pad[2];

			float ao_color[4];

			float sdf_to_bounds[16];

			int32_t sdf_offset[3];
			uint32_t material_uv2_mode;

			int32_t sdf_size[3];
			uint32_t gi_upscale_for_msaa;

			uint32_t volumetric_fog_enabled;
			float volumetric_fog_inv_length;
			float volumetric_fog_detail_spread;
			uint32_t volumetric_fog_pad;

			// Fog
			uint32_t fog_enabled;
			float fog_density;
			float fog_height;
			float fog_height_density;

			float fog_light_color[3];
			float fog_sun_scatter;

			float fog_aerial_perspective;

			float time;
			float reflection_multiplier;

			uint32_t pancake_shadows;
		};

		UBO ubo;

		RID uniform_buffer;

		LightmapData lightmaps[MAX_LIGHTMAPS];
		RID lightmap_ids[MAX_LIGHTMAPS];
		bool lightmap_has_sh[MAX_LIGHTMAPS];
		uint32_t lightmaps_used = 0;
		uint32_t max_lightmaps;
		RID lightmap_buffer;

		LightmapCaptureData *lightmap_captures;
		uint32_t max_lightmap_captures;
		RID lightmap_capture_buffer;

		RID giprobe_ids[MAX_GI_PROBES];
		uint32_t giprobes_used = 0;

		bool used_screen_texture = false;
		bool used_normal_texture = false;
		bool used_depth_texture = false;
		bool used_sss = false;

	} scene_state;

	static RendererSceneRenderForward *singleton;
	uint64_t render_pass;
	double time;
	RID default_shader;
	RID default_material;
	RID overdraw_material_shader;
	RID overdraw_material;
	RID wireframe_material_shader;
	RID wireframe_material;
	RID default_shader_rd;
	RID default_shader_sdfgi_rd;

	RID default_vec4_xform_buffer;
	RID default_vec4_xform_uniform_set;

	enum PassMode {
		PASS_MODE_COLOR,
		PASS_MODE_COLOR_SPECULAR,
		PASS_MODE_COLOR_TRANSPARENT,
		PASS_MODE_SHADOW,
		PASS_MODE_SHADOW_DP,
		PASS_MODE_DEPTH,
		PASS_MODE_DEPTH_NORMAL_ROUGHNESS,
		PASS_MODE_DEPTH_NORMAL_ROUGHNESS_GIPROBE,
		PASS_MODE_DEPTH_MATERIAL,
		PASS_MODE_SDF,
	};

	void _setup_environment(RID p_environment, RID p_render_buffers, const CameraMatrix &p_cam_projection, const Transform &p_cam_transform, RID p_reflection_probe, bool p_no_fog, const Size2 &p_screen_pixel_size, RID p_shadow_atlas, bool p_flip_y, const Color &p_default_bg_color, float p_znear, float p_zfar, bool p_opaque_render_buffers = false, bool p_pancake_shadows = false);
	void _setup_giprobes(const PagedArray<RID> &p_giprobes);
	void _setup_lightmaps(const PagedArray<RID> &p_lightmaps, const Transform &p_cam_transform);

	struct GeometryInstanceSurfaceDataCache;

	struct RenderListParameters {
		GeometryInstanceSurfaceDataCache **elements = nullptr;
		int element_count = 0;
		bool reverse_cull = false;
		PassMode pass_mode = PASS_MODE_COLOR;
		bool no_gi = false;
		RID render_pass_uniform_set;
		bool force_wireframe = false;
		Vector2 uv_offset;
		Plane lod_plane;
		float lod_distance_multiplier = 0.0;
		float screen_lod_threshold = 0.0;
		RD::FramebufferFormatID framebuffer_format = 0;
		RenderListParameters(GeometryInstanceSurfaceDataCache **p_elements, int p_element_count, bool p_reverse_cull, PassMode p_pass_mode, bool p_no_gi, RID p_render_pass_uniform_set, bool p_force_wireframe = false, const Vector2 &p_uv_offset = Vector2(), const Plane &p_lod_plane = Plane(), float p_lod_distance_multiplier = 0.0, float p_screen_lod_threshold = 0.0) {
			elements = p_elements;
			element_count = p_element_count;
			reverse_cull = p_reverse_cull;
			pass_mode = p_pass_mode;
			no_gi = p_no_gi;
			render_pass_uniform_set = p_render_pass_uniform_set;
			force_wireframe = p_force_wireframe;
			uv_offset = p_uv_offset;
			lod_plane = p_lod_plane;
			lod_distance_multiplier = p_lod_distance_multiplier;
			screen_lod_threshold = p_screen_lod_threshold;
		}
	};

	template <PassMode p_pass_mode>
	_FORCE_INLINE_ void _render_list_template(RenderingDevice::DrawListID p_draw_list, RenderingDevice::FramebufferFormatID p_framebuffer_Format, RenderListParameters *p_params, uint32_t p_from_element, uint32_t p_to_element);

	void _render_list(RenderingDevice::DrawListID p_draw_list, RenderingDevice::FramebufferFormatID p_framebuffer_Format, RenderListParameters *p_params, uint32_t p_from_element, uint32_t p_to_element);

	LocalVector<RD::DrawListID> thread_draw_lists;
	void _render_list_thread_function(uint32_t p_thread, RenderListParameters *p_params);
	void _render_list_with_threads(RenderListParameters *p_params, RID p_framebuffer, RD::InitialAction p_initial_color_action, RD::FinalAction p_final_color_action, RD::InitialAction p_initial_depth_action, RD::FinalAction p_final_depth_action, const Vector<Color> &p_clear_color_values = Vector<Color>(), float p_clear_depth = 1.0, uint32_t p_clear_stencil = 0, const Rect2 &p_region = Rect2(), const Vector<RID> &p_storage_textures = Vector<RID>());

	uint32_t render_list_thread_threshold = 500;

	void _fill_render_list(const PagedArray<GeometryInstance *> &p_instances, PassMode p_pass_mode, const CameraMatrix &p_cam_projection, const Transform &p_cam_transform, bool p_using_sdfgi = false, bool p_using_opaque_gi = false);

	Map<Size2i, RID> sdfgi_framebuffer_size_cache;

	struct GeometryInstanceData;
	struct GeometryInstanceForward;

	struct GeometryInstanceLightmapSH {
		Color sh[9];
	};

	// Cached data for drawing surfaces
	struct GeometryInstanceSurfaceDataCache {
		enum {
			FLAG_PASS_DEPTH = 1,
			FLAG_PASS_OPAQUE = 2,
			FLAG_PASS_ALPHA = 4,
			FLAG_PASS_SHADOW = 8,
			FLAG_USES_SHARED_SHADOW_MATERIAL = 128,
			FLAG_USES_SUBSURFACE_SCATTERING = 2048,
			FLAG_USES_SCREEN_TEXTURE = 4096,
			FLAG_USES_DEPTH_TEXTURE = 8192,
			FLAG_USES_NORMAL_TEXTURE = 16384,
			FLAG_USES_DOUBLE_SIDED_SHADOWS = 32768,
		};

		union {
			struct {
				uint32_t geometry_id;
				uint32_t material_id;
				uint32_t shader_id;
				uint32_t surface_type : 4;
				uint32_t uses_forward_gi : 1; //set during addition
				uint32_t uses_lightmap : 1; //set during addition
				uint32_t depth_layer : 4; //set during addition
				uint32_t priority : 8;
			};
			struct {
				uint64_t sort_key1;
				uint64_t sort_key2;
			};
		} sort;

		RS::PrimitiveType primitive = RS::PRIMITIVE_MAX;
		uint32_t flags = 0;
		uint32_t surface_index = 0;

		void *surface = nullptr;
		RID material_uniform_set;
		ShaderData *shader = nullptr;

		void *surface_shadow = nullptr;
		RID material_uniform_set_shadow;
		ShaderData *shader_shadow = nullptr;

		GeometryInstanceSurfaceDataCache *next = nullptr;
		GeometryInstanceForward *owner = nullptr;
	};

	struct GeometryInstanceForward : public GeometryInstance {
		//used during rendering
		bool mirror = false;
		bool non_uniform_scale = false;
		float lod_bias = 0.0;
		float lod_model_scale = 1.0;
		AABB transformed_aabb; //needed for LOD
		float depth = 0;
		struct PushConstant {
			float transform[16];
			uint32_t flags;
			uint32_t instance_uniforms_ofs; //base offset in global buffer for instance variables
			uint32_t gi_offset; //GI information when using lightmapping (VCT or lightmap index)
			uint32_t layer_mask;
			float lightmap_uv_scale[4];
		} push_constant;
		RID transforms_uniform_set;
		uint32_t instance_count = 0;
		RID mesh_instance;
		bool can_sdfgi = false;
		//used during setup
		uint32_t base_flags = 0;
		RID gi_probes[MAX_GI_PROBES_PER_INSTANCE];
		RID lightmap_instance;
		GeometryInstanceLightmapSH *lightmap_sh = nullptr;
		GeometryInstanceSurfaceDataCache *surface_caches = nullptr;
		SelfList<GeometryInstanceForward> dirty_list_element;

		struct Data {
			//data used less often goes into regular heap
			RID base;
			RS::InstanceType base_type;

			RID skeleton;

			uint32_t layer_mask = 1;

			Vector<RID> surface_materials;
			RID material_override;
			Transform transform;
			AABB aabb;
			int32_t shader_parameters_offset = -1;

			bool use_dynamic_gi = false;
			bool use_baked_light = false;
			bool cast_double_sided_shaodows = false;
			bool mirror = false;
			Rect2 lightmap_uv_scale;
			uint32_t lightmap_slice_index = 0;
			bool dirty_dependencies = false;

			RendererStorage::DependencyTracker dependency_tracker;
		};

		Data *data = nullptr;

		GeometryInstanceForward() :
				dirty_list_element(this) {}
	};

	static void _geometry_instance_dependency_changed(RendererStorage::DependencyChangedNotification p_notification, RendererStorage::DependencyTracker *p_tracker);
	static void _geometry_instance_dependency_deleted(const RID &p_dependency, RendererStorage::DependencyTracker *p_tracker);

	SelfList<GeometryInstanceForward>::List geometry_instance_dirty_list;

	PagedAllocator<GeometryInstanceForward> geometry_instance_alloc;
	PagedAllocator<GeometryInstanceSurfaceDataCache> geometry_instance_surface_alloc;
	PagedAllocator<GeometryInstanceLightmapSH> geometry_instance_lightmap_sh;

	void _geometry_instance_add_surface_with_material(GeometryInstanceForward *ginstance, uint32_t p_surface, MaterialData *p_material, uint32_t p_material_id, uint32_t p_shader_id, RID p_mesh);
	void _geometry_instance_add_surface(GeometryInstanceForward *ginstance, uint32_t p_surface, RID p_material, RID p_mesh);
	void _geometry_instance_mark_dirty(GeometryInstance *p_geometry_instance);
	void _geometry_instance_update(GeometryInstance *p_geometry_instance);
	void _update_dirty_geometry_instances();

	bool low_end = false;

	/* Render List */

	struct RenderList {
		int max_elements;

		GeometryInstanceSurfaceDataCache **elements = nullptr;

		int element_count;
		int alpha_element_count;

		void clear() {
			element_count = 0;
			alpha_element_count = 0;
		}

		//should eventually be replaced by radix

		struct SortByKey {
			_FORCE_INLINE_ bool operator()(const GeometryInstanceSurfaceDataCache *A, const GeometryInstanceSurfaceDataCache *B) const {
				return (A->sort.sort_key2 == B->sort.sort_key2) ? (A->sort.sort_key1 < B->sort.sort_key1) : (A->sort.sort_key2 < B->sort.sort_key2);
			}
		};

		void sort_by_key(bool p_alpha) {
			SortArray<GeometryInstanceSurfaceDataCache *, SortByKey> sorter;
			if (p_alpha) {
				sorter.sort(&elements[max_elements - alpha_element_count], alpha_element_count);
			} else {
				sorter.sort(elements, element_count);
			}
		}

		struct SortByDepth {
			_FORCE_INLINE_ bool operator()(const GeometryInstanceSurfaceDataCache *A, const GeometryInstanceSurfaceDataCache *B) const {
				return (A->owner->depth < B->owner->depth);
			}
		};

		void sort_by_depth(bool p_alpha) { //used for shadows

			SortArray<GeometryInstanceSurfaceDataCache *, SortByDepth> sorter;
			if (p_alpha) {
				sorter.sort(&elements[max_elements - alpha_element_count], alpha_element_count);
			} else {
				sorter.sort(elements, element_count);
			}
		}

		struct SortByReverseDepthAndPriority {
			_FORCE_INLINE_ bool operator()(const GeometryInstanceSurfaceDataCache *A, const GeometryInstanceSurfaceDataCache *B) const {
				return (A->sort.priority == B->sort.priority) ? (A->owner->depth > B->owner->depth) : (A->sort.priority < B->sort.priority);
			}
		};

		void sort_by_reverse_depth_and_priority(bool p_alpha) { //used for alpha

			SortArray<GeometryInstanceSurfaceDataCache *, SortByReverseDepthAndPriority> sorter;
			if (p_alpha) {
				sorter.sort(&elements[max_elements - alpha_element_count], alpha_element_count);
			} else {
				sorter.sort(elements, element_count);
			}
		}

		_FORCE_INLINE_ void add_element(GeometryInstanceSurfaceDataCache *p_element) {
			if (element_count + alpha_element_count >= max_elements) {
				return;
			}
			elements[element_count] = p_element;
			element_count++;
		}

		_FORCE_INLINE_ void add_alpha_element(GeometryInstanceSurfaceDataCache *p_element) {
			if (element_count + alpha_element_count >= max_elements) {
				return;
			}
			int idx = max_elements - alpha_element_count - 1;
			elements[idx] = p_element;
			alpha_element_count++;
		}

		void init() {
			element_count = 0;
			alpha_element_count = 0;
			elements = memnew_arr(GeometryInstanceSurfaceDataCache *, max_elements);
		}

		RenderList() {
			max_elements = 0;
		}

		~RenderList() {
			memdelete_arr(elements);
		}
	};

	RenderList render_list;

protected:
	virtual void _render_scene(RID p_render_buffer, const Transform &p_cam_transform, const CameraMatrix &p_cam_projection, bool p_cam_ortogonal, const PagedArray<GeometryInstance *> &p_instances, int p_directional_light_count, const PagedArray<RID> &p_gi_probes, const PagedArray<RID> &p_lightmaps, RID p_environment, RID p_camera_effects, RID p_shadow_atlas, RID p_reflection_atlas, RID p_reflection_probe, int p_reflection_probe_pass, const Color &p_default_bg_color, float p_lod_threshold);
	virtual void _render_shadow(RID p_framebuffer, const PagedArray<GeometryInstance *> &p_instances, const CameraMatrix &p_projection, const Transform &p_transform, float p_zfar, float p_bias, float p_normal_bias, bool p_use_dp, bool p_use_dp_flip, bool p_use_pancake, const Plane &p_camera_plane = Plane(), float p_lod_distance_multiplier = 0.0, float p_screen_lod_threshold = 0.0);
	virtual void _render_material(const Transform &p_cam_transform, const CameraMatrix &p_cam_projection, bool p_cam_ortogonal, const PagedArray<GeometryInstance *> &p_instances, RID p_framebuffer, const Rect2i &p_region);
	virtual void _render_uv2(const PagedArray<GeometryInstance *> &p_instances, RID p_framebuffer, const Rect2i &p_region);
	virtual void _render_sdfgi(RID p_render_buffers, const Vector3i &p_from, const Vector3i &p_size, const AABB &p_bounds, const PagedArray<GeometryInstance *> &p_instances, const RID &p_albedo_texture, const RID &p_emission_texture, const RID &p_emission_aniso_texture, const RID &p_geom_facing_texture);
	virtual void _render_particle_collider_heightfield(RID p_fb, const Transform &p_cam_transform, const CameraMatrix &p_cam_projection, const PagedArray<GeometryInstance *> &p_instances);

public:
	virtual GeometryInstance *geometry_instance_create(RID p_base);
	virtual void geometry_instance_set_skeleton(GeometryInstance *p_geometry_instance, RID p_skeleton);
	virtual void geometry_instance_set_material_override(GeometryInstance *p_geometry_instance, RID p_override);
	virtual void geometry_instance_set_surface_materials(GeometryInstance *p_geometry_instance, const Vector<RID> &p_materials);
	virtual void geometry_instance_set_mesh_instance(GeometryInstance *p_geometry_instance, RID p_mesh_instance);
	virtual void geometry_instance_set_transform(GeometryInstance *p_geometry_instance, const Transform &p_transform, const AABB &p_aabb, const AABB &p_transformed_aabb);
	virtual void geometry_instance_set_layer_mask(GeometryInstance *p_geometry_instance, uint32_t p_layer_mask);
	virtual void geometry_instance_set_lod_bias(GeometryInstance *p_geometry_instance, float p_lod_bias);
	virtual void geometry_instance_set_use_baked_light(GeometryInstance *p_geometry_instance, bool p_enable);
	virtual void geometry_instance_set_use_dynamic_gi(GeometryInstance *p_geometry_instance, bool p_enable);
	virtual void geometry_instance_set_use_lightmap(GeometryInstance *p_geometry_instance, RID p_lightmap_instance, const Rect2 &p_lightmap_uv_scale, int p_lightmap_slice_index);
	virtual void geometry_instance_set_lightmap_capture(GeometryInstance *p_geometry_instance, const Color *p_sh9);
	virtual void geometry_instance_set_instance_shader_parameters_offset(GeometryInstance *p_geometry_instance, int32_t p_offset);
	virtual void geometry_instance_set_cast_double_sided_shadows(GeometryInstance *p_geometry_instance, bool p_enable);

	virtual Transform geometry_instance_get_transform(GeometryInstance *p_instance);
	virtual AABB geometry_instance_get_aabb(GeometryInstance *p_instance);

	virtual void geometry_instance_free(GeometryInstance *p_geometry_instance);

	virtual uint32_t geometry_instance_get_pair_mask();
	virtual void geometry_instance_pair_light_instances(GeometryInstance *p_geometry_instance, const RID *p_light_instances, uint32_t p_light_instance_count);
	virtual void geometry_instance_pair_reflection_probe_instances(GeometryInstance *p_geometry_instance, const RID *p_reflection_probe_instances, uint32_t p_reflection_probe_instance_count);
	virtual void geometry_instance_pair_decal_instances(GeometryInstance *p_geometry_instance, const RID *p_decal_instances, uint32_t p_decal_instance_count);
	virtual void geometry_instance_pair_gi_probe_instances(GeometryInstance *p_geometry_instance, const RID *p_gi_probe_instances, uint32_t p_gi_probe_instance_count);

	virtual void set_time(double p_time, double p_step);

	virtual bool free(RID p_rid);

	RendererSceneRenderForward(RendererStorageRD *p_storage);
	~RendererSceneRenderForward();
};
#endif // RASTERIZER_SCENE_HIGHEND_RD_H
