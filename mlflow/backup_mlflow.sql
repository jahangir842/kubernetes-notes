PGDMP                         }            mlflowdb %   14.15 (Ubuntu 14.15-0ubuntu0.22.04.1) %   14.15 (Ubuntu 14.15-0ubuntu0.22.04.1) \    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16384    mlflowdb    DATABASE     ]   CREATE DATABASE mlflowdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';
    DROP DATABASE mlflowdb;
                postgres    false            �           0    0    DATABASE mlflowdb    ACL     )   GRANT ALL ON DATABASE mlflowdb TO admin;
                   postgres    false    3515            �            1259    16447    alembic_version    TABLE     X   CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);
 #   DROP TABLE public.alembic_version;
       public         heap    admin    false            �            1259    16551    datasets    TABLE     X  CREATE TABLE public.datasets (
    dataset_uuid character varying(36) NOT NULL,
    experiment_id integer NOT NULL,
    name character varying(500) NOT NULL,
    digest character varying(36) NOT NULL,
    dataset_source_type character varying(36) NOT NULL,
    dataset_source text NOT NULL,
    dataset_schema text,
    dataset_profile text
);
    DROP TABLE public.datasets;
       public         heap    admin    false            �            1259    16460    experiment_tags    TABLE     �   CREATE TABLE public.experiment_tags (
    key character varying(250) NOT NULL,
    value character varying(5000),
    experiment_id integer NOT NULL
);
 #   DROP TABLE public.experiment_tags;
       public         heap    admin    false            �            1259    16387    experiments    TABLE     �  CREATE TABLE public.experiments (
    experiment_id bigint NOT NULL,
    name character varying(256) NOT NULL,
    artifact_location character varying(256),
    lifecycle_stage character varying(32),
    creation_time bigint,
    last_update_time bigint,
    CONSTRAINT experiments_lifecycle_stage CHECK (((lifecycle_stage)::text = ANY ((ARRAY['active'::character varying, 'deleted'::character varying])::text[])))
);
    DROP TABLE public.experiments;
       public         heap    admin    false            �            1259    16386    experiments_experiment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.experiments_experiment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.experiments_experiment_id_seq;
       public          admin    false    210            �           0    0    experiments_experiment_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.experiments_experiment_id_seq OWNED BY public.experiments.experiment_id;
          public          admin    false    209            �            1259    16572 
   input_tags    TABLE     �   CREATE TABLE public.input_tags (
    input_uuid character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(500) NOT NULL
);
    DROP TABLE public.input_tags;
       public         heap    admin    false            �            1259    16565    inputs    TABLE       CREATE TABLE public.inputs (
    input_uuid character varying(36) NOT NULL,
    source_type character varying(36) NOT NULL,
    source_id character varying(36) NOT NULL,
    destination_type character varying(36) NOT NULL,
    destination_id character varying(36) NOT NULL
);
    DROP TABLE public.inputs;
       public         heap    admin    false            �            1259    16472    latest_metrics    TABLE     �   CREATE TABLE public.latest_metrics (
    key character varying(250) NOT NULL,
    value double precision NOT NULL,
    "timestamp" bigint,
    step bigint NOT NULL,
    is_nan boolean NOT NULL,
    run_uuid character varying(32) NOT NULL
);
 "   DROP TABLE public.latest_metrics;
       public         heap    admin    false            �            1259    16425    metrics    TABLE       CREATE TABLE public.metrics (
    key character varying(250) NOT NULL,
    value double precision NOT NULL,
    "timestamp" bigint NOT NULL,
    run_uuid character varying(32) NOT NULL,
    step bigint DEFAULT '0'::bigint NOT NULL,
    is_nan boolean DEFAULT false NOT NULL
);
    DROP TABLE public.metrics;
       public         heap    admin    false            �            1259    16520    model_version_tags    TABLE     �   CREATE TABLE public.model_version_tags (
    key character varying(250) NOT NULL,
    value character varying(5000),
    name character varying(256) NOT NULL,
    version integer NOT NULL
);
 &   DROP TABLE public.model_version_tags;
       public         heap    admin    false            �            1259    16489    model_versions    TABLE       CREATE TABLE public.model_versions (
    name character varying(256) NOT NULL,
    version integer NOT NULL,
    creation_time bigint,
    last_updated_time bigint,
    description character varying(5000),
    user_id character varying(256),
    current_stage character varying(20),
    source character varying(500),
    run_id character varying(32),
    status character varying(20),
    status_message character varying(500),
    run_link character varying(500),
    storage_location character varying(500)
);
 "   DROP TABLE public.model_versions;
       public         heap    admin    false            �            1259    16435    params    TABLE     �   CREATE TABLE public.params (
    key character varying(250) NOT NULL,
    value character varying(8000) NOT NULL,
    run_uuid character varying(32) NOT NULL
);
    DROP TABLE public.params;
       public         heap    admin    false            �            1259    16539    registered_model_aliases    TABLE     �   CREATE TABLE public.registered_model_aliases (
    alias character varying(256) NOT NULL,
    version integer NOT NULL,
    name character varying(256) NOT NULL
);
 ,   DROP TABLE public.registered_model_aliases;
       public         heap    admin    false            �            1259    16508    registered_model_tags    TABLE     �   CREATE TABLE public.registered_model_tags (
    key character varying(250) NOT NULL,
    value character varying(5000),
    name character varying(256) NOT NULL
);
 )   DROP TABLE public.registered_model_tags;
       public         heap    admin    false            �            1259    16482    registered_models    TABLE     �   CREATE TABLE public.registered_models (
    name character varying(256) NOT NULL,
    creation_time bigint,
    last_updated_time bigint,
    description character varying(5000)
);
 %   DROP TABLE public.registered_models;
       public         heap    admin    false            �            1259    16398    runs    TABLE     p  CREATE TABLE public.runs (
    run_uuid character varying(32) NOT NULL,
    name character varying(250),
    source_type character varying(20),
    source_name character varying(500),
    entry_point_name character varying(50),
    user_id character varying(256),
    status character varying(9),
    start_time bigint,
    end_time bigint,
    source_version character varying(50),
    lifecycle_stage character varying(20),
    artifact_uri character varying(200),
    experiment_id integer,
    deleted_time bigint,
    CONSTRAINT runs_lifecycle_stage CHECK (((lifecycle_stage)::text = ANY ((ARRAY['active'::character varying, 'deleted'::character varying])::text[]))),
    CONSTRAINT runs_status_check CHECK (((status)::text = ANY ((ARRAY['SCHEDULED'::character varying, 'FAILED'::character varying, 'FINISHED'::character varying, 'RUNNING'::character varying, 'KILLED'::character varying])::text[]))),
    CONSTRAINT source_type CHECK (((source_type)::text = ANY ((ARRAY['NOTEBOOK'::character varying, 'JOB'::character varying, 'LOCAL'::character varying, 'UNKNOWN'::character varying, 'PROJECT'::character varying])::text[])))
);
    DROP TABLE public.runs;
       public         heap    admin    false            �            1259    16413    tags    TABLE     �   CREATE TABLE public.tags (
    key character varying(250) NOT NULL,
    value character varying(8000),
    run_uuid character varying(32) NOT NULL
);
    DROP TABLE public.tags;
       public         heap    admin    false            �            1259    16579 
   trace_info    TABLE     �   CREATE TABLE public.trace_info (
    request_id character varying(50) NOT NULL,
    experiment_id integer NOT NULL,
    timestamp_ms bigint NOT NULL,
    execution_time_ms bigint,
    status character varying(50) NOT NULL
);
    DROP TABLE public.trace_info;
       public         heap    admin    false            �            1259    16603    trace_request_metadata    TABLE     �   CREATE TABLE public.trace_request_metadata (
    key character varying(250) NOT NULL,
    value character varying(8000),
    request_id character varying(50) NOT NULL
);
 *   DROP TABLE public.trace_request_metadata;
       public         heap    admin    false            �            1259    16590 
   trace_tags    TABLE     �   CREATE TABLE public.trace_tags (
    key character varying(250) NOT NULL,
    value character varying(8000),
    request_id character varying(50) NOT NULL
);
    DROP TABLE public.trace_tags;
       public         heap    admin    false            �           2604    16632    experiments experiment_id    DEFAULT     �   ALTER TABLE ONLY public.experiments ALTER COLUMN experiment_id SET DEFAULT nextval('public.experiments_experiment_id_seq'::regclass);
 H   ALTER TABLE public.experiments ALTER COLUMN experiment_id DROP DEFAULT;
       public          admin    false    210    209    210            �          0    16447    alembic_version 
   TABLE DATA           6   COPY public.alembic_version (version_num) FROM stdin;
    public          admin    false    215   Y{       �          0    16551    datasets 
   TABLE DATA           �   COPY public.datasets (dataset_uuid, experiment_id, name, digest, dataset_source_type, dataset_source, dataset_schema, dataset_profile) FROM stdin;
    public          admin    false    223   �{       �          0    16460    experiment_tags 
   TABLE DATA           D   COPY public.experiment_tags (key, value, experiment_id) FROM stdin;
    public          admin    false    216   �{       �          0    16387    experiments 
   TABLE DATA              COPY public.experiments (experiment_id, name, artifact_location, lifecycle_stage, creation_time, last_update_time) FROM stdin;
    public          admin    false    210   �{       �          0    16572 
   input_tags 
   TABLE DATA           =   COPY public.input_tags (input_uuid, name, value) FROM stdin;
    public          admin    false    225   �}       �          0    16565    inputs 
   TABLE DATA           f   COPY public.inputs (input_uuid, source_type, source_id, destination_type, destination_id) FROM stdin;
    public          admin    false    224   ~       �          0    16472    latest_metrics 
   TABLE DATA           Y   COPY public.latest_metrics (key, value, "timestamp", step, is_nan, run_uuid) FROM stdin;
    public          admin    false    217   4~       �          0    16425    metrics 
   TABLE DATA           R   COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
    public          admin    false    213   ��       �          0    16520    model_version_tags 
   TABLE DATA           G   COPY public.model_version_tags (key, value, name, version) FROM stdin;
    public          admin    false    221   �$      �          0    16489    model_versions 
   TABLE DATA           �   COPY public.model_versions (name, version, creation_time, last_updated_time, description, user_id, current_stage, source, run_id, status, status_message, run_link, storage_location) FROM stdin;
    public          admin    false    219   N%      �          0    16435    params 
   TABLE DATA           6   COPY public.params (key, value, run_uuid) FROM stdin;
    public          admin    false    214   f'      �          0    16539    registered_model_aliases 
   TABLE DATA           H   COPY public.registered_model_aliases (alias, version, name) FROM stdin;
    public          admin    false    222   ڗ      �          0    16508    registered_model_tags 
   TABLE DATA           A   COPY public.registered_model_tags (key, value, name) FROM stdin;
    public          admin    false    220   ��      �          0    16482    registered_models 
   TABLE DATA           `   COPY public.registered_models (name, creation_time, last_updated_time, description) FROM stdin;
    public          admin    false    218   �      �          0    16398    runs 
   TABLE DATA           �   COPY public.runs (run_uuid, name, source_type, source_name, entry_point_name, user_id, status, start_time, end_time, source_version, lifecycle_stage, artifact_uri, experiment_id, deleted_time) FROM stdin;
    public          admin    false    211   ��      �          0    16413    tags 
   TABLE DATA           4   COPY public.tags (key, value, run_uuid) FROM stdin;
    public          admin    false    212   C�      �          0    16579 
   trace_info 
   TABLE DATA           h   COPY public.trace_info (request_id, experiment_id, timestamp_ms, execution_time_ms, status) FROM stdin;
    public          admin    false    226   =�      �          0    16603    trace_request_metadata 
   TABLE DATA           H   COPY public.trace_request_metadata (key, value, request_id) FROM stdin;
    public          admin    false    228   Z�      �          0    16590 
   trace_tags 
   TABLE DATA           <   COPY public.trace_tags (key, value, request_id) FROM stdin;
    public          admin    false    227   w�      �           0    0    experiments_experiment_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.experiments_experiment_id_seq', 17, true);
          public          admin    false    209            �           2606    16451 #   alembic_version alembic_version_pkc 
   CONSTRAINT     j   ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);
 M   ALTER TABLE ONLY public.alembic_version DROP CONSTRAINT alembic_version_pkc;
       public            admin    false    215            �           2606    16557    datasets dataset_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT dataset_pk PRIMARY KEY (experiment_id, name, digest);
 =   ALTER TABLE ONLY public.datasets DROP CONSTRAINT dataset_pk;
       public            admin    false    223    223    223            �           2606    16634    experiments experiment_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.experiments
    ADD CONSTRAINT experiment_pk PRIMARY KEY (experiment_id);
 C   ALTER TABLE ONLY public.experiments DROP CONSTRAINT experiment_pk;
       public            admin    false    210            �           2606    16466 !   experiment_tags experiment_tag_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.experiment_tags
    ADD CONSTRAINT experiment_tag_pk PRIMARY KEY (key, experiment_id);
 K   ALTER TABLE ONLY public.experiment_tags DROP CONSTRAINT experiment_tag_pk;
       public            admin    false    216    216            �           2606    16397     experiments experiments_name_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.experiments
    ADD CONSTRAINT experiments_name_key UNIQUE (name);
 J   ALTER TABLE ONLY public.experiments DROP CONSTRAINT experiments_name_key;
       public            admin    false    210            �           2606    16578    input_tags input_tags_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.input_tags
    ADD CONSTRAINT input_tags_pk PRIMARY KEY (input_uuid, name);
 B   ALTER TABLE ONLY public.input_tags DROP CONSTRAINT input_tags_pk;
       public            admin    false    225    225            �           2606    16569    inputs inputs_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.inputs
    ADD CONSTRAINT inputs_pk PRIMARY KEY (source_type, source_id, destination_type, destination_id);
 :   ALTER TABLE ONLY public.inputs DROP CONSTRAINT inputs_pk;
       public            admin    false    224    224    224    224            �           2606    16476    latest_metrics latest_metric_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.latest_metrics
    ADD CONSTRAINT latest_metric_pk PRIMARY KEY (key, run_uuid);
 I   ALTER TABLE ONLY public.latest_metrics DROP CONSTRAINT latest_metric_pk;
       public            admin    false    217    217            �           2606    16534    metrics metric_pk 
   CONSTRAINT     |   ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metric_pk PRIMARY KEY (key, "timestamp", step, run_uuid, value, is_nan);
 ;   ALTER TABLE ONLY public.metrics DROP CONSTRAINT metric_pk;
       public            admin    false    213    213    213    213    213    213            �           2606    16495    model_versions model_version_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.model_versions
    ADD CONSTRAINT model_version_pk PRIMARY KEY (name, version);
 I   ALTER TABLE ONLY public.model_versions DROP CONSTRAINT model_version_pk;
       public            admin    false    219    219            �           2606    16526 '   model_version_tags model_version_tag_pk 
   CONSTRAINT     u   ALTER TABLE ONLY public.model_version_tags
    ADD CONSTRAINT model_version_tag_pk PRIMARY KEY (key, name, version);
 Q   ALTER TABLE ONLY public.model_version_tags DROP CONSTRAINT model_version_tag_pk;
       public            admin    false    221    221    221            �           2606    16441    params param_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.params
    ADD CONSTRAINT param_pk PRIMARY KEY (key, run_uuid);
 9   ALTER TABLE ONLY public.params DROP CONSTRAINT param_pk;
       public            admin    false    214    214            �           2606    16545 2   registered_model_aliases registered_model_alias_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.registered_model_aliases
    ADD CONSTRAINT registered_model_alias_pk PRIMARY KEY (name, alias);
 \   ALTER TABLE ONLY public.registered_model_aliases DROP CONSTRAINT registered_model_alias_pk;
       public            admin    false    222    222            �           2606    16488 %   registered_models registered_model_pk 
   CONSTRAINT     e   ALTER TABLE ONLY public.registered_models
    ADD CONSTRAINT registered_model_pk PRIMARY KEY (name);
 O   ALTER TABLE ONLY public.registered_models DROP CONSTRAINT registered_model_pk;
       public            admin    false    218            �           2606    16514 -   registered_model_tags registered_model_tag_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.registered_model_tags
    ADD CONSTRAINT registered_model_tag_pk PRIMARY KEY (key, name);
 W   ALTER TABLE ONLY public.registered_model_tags DROP CONSTRAINT registered_model_tag_pk;
       public            admin    false    220    220            �           2606    16407    runs run_pk 
   CONSTRAINT     O   ALTER TABLE ONLY public.runs
    ADD CONSTRAINT run_pk PRIMARY KEY (run_uuid);
 5   ALTER TABLE ONLY public.runs DROP CONSTRAINT run_pk;
       public            admin    false    211            �           2606    16419    tags tag_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tag_pk PRIMARY KEY (key, run_uuid);
 5   ALTER TABLE ONLY public.tags DROP CONSTRAINT tag_pk;
       public            admin    false    212    212                       2606    16583    trace_info trace_info_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.trace_info
    ADD CONSTRAINT trace_info_pk PRIMARY KEY (request_id);
 B   ALTER TABLE ONLY public.trace_info DROP CONSTRAINT trace_info_pk;
       public            admin    false    226                       2606    16609 0   trace_request_metadata trace_request_metadata_pk 
   CONSTRAINT     {   ALTER TABLE ONLY public.trace_request_metadata
    ADD CONSTRAINT trace_request_metadata_pk PRIMARY KEY (key, request_id);
 Z   ALTER TABLE ONLY public.trace_request_metadata DROP CONSTRAINT trace_request_metadata_pk;
       public            admin    false    228    228                       2606    16596    trace_tags trace_tag_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.trace_tags
    ADD CONSTRAINT trace_tag_pk PRIMARY KEY (key, request_id);
 A   ALTER TABLE ONLY public.trace_tags DROP CONSTRAINT trace_tag_pk;
       public            admin    false    227    227            �           1259    16563    index_datasets_dataset_uuid    INDEX     X   CREATE INDEX index_datasets_dataset_uuid ON public.datasets USING btree (dataset_uuid);
 /   DROP INDEX public.index_datasets_dataset_uuid;
       public            admin    false    223            �           1259    16564 0   index_datasets_experiment_id_dataset_source_type    INDEX     �   CREATE INDEX index_datasets_experiment_id_dataset_source_type ON public.datasets USING btree (experiment_id, dataset_source_type);
 D   DROP INDEX public.index_datasets_experiment_id_dataset_source_type;
       public            admin    false    223    223            �           1259    16571 8   index_inputs_destination_type_destination_id_source_type    INDEX     �   CREATE INDEX index_inputs_destination_type_destination_id_source_type ON public.inputs USING btree (destination_type, destination_id, source_type);
 L   DROP INDEX public.index_inputs_destination_type_destination_id_source_type;
       public            admin    false    224    224    224            �           1259    16570    index_inputs_input_uuid    INDEX     P   CREATE INDEX index_inputs_input_uuid ON public.inputs USING btree (input_uuid);
 +   DROP INDEX public.index_inputs_input_uuid;
       public            admin    false    224            �           1259    16537    index_latest_metrics_run_uuid    INDEX     \   CREATE INDEX index_latest_metrics_run_uuid ON public.latest_metrics USING btree (run_uuid);
 1   DROP INDEX public.index_latest_metrics_run_uuid;
       public            admin    false    217            �           1259    16536    index_metrics_run_uuid    INDEX     N   CREATE INDEX index_metrics_run_uuid ON public.metrics USING btree (run_uuid);
 *   DROP INDEX public.index_metrics_run_uuid;
       public            admin    false    213            �           1259    16535    index_params_run_uuid    INDEX     L   CREATE INDEX index_params_run_uuid ON public.params USING btree (run_uuid);
 )   DROP INDEX public.index_params_run_uuid;
       public            admin    false    214            �           1259    16538    index_tags_run_uuid    INDEX     H   CREATE INDEX index_tags_run_uuid ON public.tags USING btree (run_uuid);
 '   DROP INDEX public.index_tags_run_uuid;
       public            admin    false    212                        1259    16589 +   index_trace_info_experiment_id_timestamp_ms    INDEX     y   CREATE INDEX index_trace_info_experiment_id_timestamp_ms ON public.trace_info USING btree (experiment_id, timestamp_ms);
 ?   DROP INDEX public.index_trace_info_experiment_id_timestamp_ms;
       public            admin    false    226    226                       1259    16615 '   index_trace_request_metadata_request_id    INDEX     p   CREATE INDEX index_trace_request_metadata_request_id ON public.trace_request_metadata USING btree (request_id);
 ;   DROP INDEX public.index_trace_request_metadata_request_id;
       public            admin    false    228                       1259    16602    index_trace_tags_request_id    INDEX     X   CREATE INDEX index_trace_tags_request_id ON public.trace_tags USING btree (request_id);
 /   DROP INDEX public.index_trace_tags_request_id;
       public            admin    false    227                       2606    16640 2   experiment_tags experiment_tags_experiment_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.experiment_tags
    ADD CONSTRAINT experiment_tags_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);
 \   ALTER TABLE ONLY public.experiment_tags DROP CONSTRAINT experiment_tags_experiment_id_fkey;
       public          admin    false    210    216    3287                       2606    16650 .   datasets fk_datasets_experiment_id_experiments    FK CONSTRAINT     �   ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT fk_datasets_experiment_id_experiments FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.datasets DROP CONSTRAINT fk_datasets_experiment_id_experiments;
       public          admin    false    210    223    3287                       2606    16645 &   trace_info fk_trace_info_experiment_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.trace_info
    ADD CONSTRAINT fk_trace_info_experiment_id FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);
 P   ALTER TABLE ONLY public.trace_info DROP CONSTRAINT fk_trace_info_experiment_id;
       public          admin    false    3287    226    210                       2606    16621 ;   trace_request_metadata fk_trace_request_metadata_request_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.trace_request_metadata
    ADD CONSTRAINT fk_trace_request_metadata_request_id FOREIGN KEY (request_id) REFERENCES public.trace_info(request_id) ON DELETE CASCADE;
 e   ALTER TABLE ONLY public.trace_request_metadata DROP CONSTRAINT fk_trace_request_metadata_request_id;
       public          admin    false    228    226    3330                       2606    16616 #   trace_tags fk_trace_tags_request_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.trace_tags
    ADD CONSTRAINT fk_trace_tags_request_id FOREIGN KEY (request_id) REFERENCES public.trace_info(request_id) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.trace_tags DROP CONSTRAINT fk_trace_tags_request_id;
       public          admin    false    227    226    3330                       2606    16477 +   latest_metrics latest_metrics_run_uuid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.latest_metrics
    ADD CONSTRAINT latest_metrics_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);
 U   ALTER TABLE ONLY public.latest_metrics DROP CONSTRAINT latest_metrics_run_uuid_fkey;
       public          admin    false    211    217    3291                       2606    16430    metrics metrics_run_uuid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);
 G   ALTER TABLE ONLY public.metrics DROP CONSTRAINT metrics_run_uuid_fkey;
       public          admin    false    211    213    3291                       2606    16527 7   model_version_tags model_version_tags_name_version_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_version_tags
    ADD CONSTRAINT model_version_tags_name_version_fkey FOREIGN KEY (name, version) REFERENCES public.model_versions(name, version) ON UPDATE CASCADE;
 a   ALTER TABLE ONLY public.model_version_tags DROP CONSTRAINT model_version_tags_name_version_fkey;
       public          admin    false    3311    219    219    221    221                       2606    16496 '   model_versions model_versions_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_versions
    ADD CONSTRAINT model_versions_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE;
 Q   ALTER TABLE ONLY public.model_versions DROP CONSTRAINT model_versions_name_fkey;
       public          admin    false    218    219    3309                       2606    16442    params params_run_uuid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.params
    ADD CONSTRAINT params_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);
 E   ALTER TABLE ONLY public.params DROP CONSTRAINT params_run_uuid_fkey;
       public          admin    false    214    3291    211                       2606    16546 9   registered_model_aliases registered_model_alias_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registered_model_aliases
    ADD CONSTRAINT registered_model_alias_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.registered_model_aliases DROP CONSTRAINT registered_model_alias_name_fkey;
       public          admin    false    218    3309    222                       2606    16515 5   registered_model_tags registered_model_tags_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registered_model_tags
    ADD CONSTRAINT registered_model_tags_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE;
 _   ALTER TABLE ONLY public.registered_model_tags DROP CONSTRAINT registered_model_tags_name_fkey;
       public          admin    false    218    220    3309            	           2606    16635    runs runs_experiment_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.runs
    ADD CONSTRAINT runs_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);
 F   ALTER TABLE ONLY public.runs DROP CONSTRAINT runs_experiment_id_fkey;
       public          admin    false    210    3287    211            
           2606    16420    tags tags_run_uuid_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);
 A   ALTER TABLE ONLY public.tags DROP CONSTRAINT tags_run_uuid_fkey;
       public          admin    false    3291    212    211            �      x�30�0IJI65�LM����� +�      �      x������ � �      �      x������ � �      �   -  x����j�0@����lwft�14-}H�ІB����v����Iڿ��f/
k��ɌA�HsC�9>������؍b�Im��W��[��|ۧ���y۬��4���^U�?P��&��N k�h}�nb'A\�U������[$��_����Z&�Z|��8�}��n������*n�r3,ԧj�N��v<qu-�~�;&�/�v4�D:a�3tl�`ѓ1vo `�x�`�L�
��k{Ph2�%��J�z���}�:uj�n�0N��$ko	�d��I��`�`����CƃfOҊoq���7��-���9�����e��Ux>�K������"x�&����+�&Uȍi�:��a�>��7	�+an�<b��e�N*��_��|�{�@�tA�<�^<���|��U�u�a���V�W{�Dk�Ґ᠑��`'ќ��딏��zܨ�ØZuS�U�a�0C���$N�)���.e$s6�&�)�-!&XCe$�?F.�ES���o^M���S_���3��;�O]�,e>m �y}`��sY4M�V�UN�b���)"?��ygٖ���NJ��@�      �      x������ � �      �      x������ � �      �      x�����n�˯���$�~�T���vN�l�$9��}��̐�=��l��Y�:�$�;�=�4��c��狻I��'�8�/�����!�y���pv��Cf?/2���ۏ<߾}��?~u�5��>�P��Ǽ�Cx�8����� ��!�A2'���<b�>�1��
e��?��?��?���w�����;��X�I�������0O$,S䜰_`/C�Y(��@/����W@�1A����U_g�Eqi�q$�/�����,�n�Y���� S(�M:�i�Y�0��" g��^��3P�f�o})��Q�m���EŝuhIy�C��_Ҙ8^B����(SvSv#ђ�p�!�.�u'�쓺�0f�a�hP��� {�2���]�%�Á�k�i&�e���pF\�as�gK�ˀ�&���z~d�#'��4�*�t	 H)������b�g�U	�c�yT?�C��x���V�#��w�KY�q�C>�����`��F�+�i���ܘT��f�0�H^5���\bb�p1�*O��#f��ā�@����	he86J��ؠc���Uif�8�G�j���I�y��}��'���l�N�٠W ��9��5�X��s&�c^"���5�{�-�ס��L�^����K�ܞn-sP��j��/�D�Ҳ�vgK��6�P�f�^������.U=�hLn��4#cw>�	h%0�S`6����i�[#�92O#`�Z�8�i�K��^�6�P�f�^
,I�|g˖rN!!f���ػ4j"���0��%?mf�t���f���-j�a���􋖑4�iԜ��#����{Z�D��	z-�b�T�����q�<�rШ1�?�8��{�
�@��z)��u��I��ŗd_�/?/����˔g6h���F`J��,�+�y����9�$��biU;'��%.Z��n���f��
������/�qQ������֧S�� OI�CXF
�:G���?~�׿���S���n1'$�@vH��oy��׿�����W�5T�N��_���W�c%i��7�׏�_}���_���g��XVwR�䣮+��6��C-��I�ט��H&:�oΥX�)��TV������ןy���\�H�Ej�hV{�����ȩr�=� n^͑c�	T�s��������r�h�y'��{g���}]t�_�0��IR��j\��.=��v�oU��*�J�:�濿O��j�v�3/��P\������u۝����-����]A���B-'�&9a=�ze���4��W��+�M��X��MJ�T�����(�x��ȳp�"n�'/Y�I�Y�@���),f���1��P�b<B���Y'� ��%��K=�z��7	BZ�9�T�&�vt��������s�jm��V�5?�����C"�P���PlF�<�1r�]�:����N�$�.1A,�l���<k%��<%uM�����(�!���z
�8�m
Kr�2�uVì�����@�) *D(�TSB��S��$;�)u� ���"{���x�-�A��L8������eq��W��F	kJ�n�)z;���R%,����2�s�	jh4C/|4�5�w"�yk����XQ٠*��SG�ه�D�������=:W����������,R�]�J�S�4�j7�i�-i�*`A7�y.�."�V��iʃn��I?���$s�A�Ǟ��怞��Aݕ5(`����&���X�s�y`�̱�	z4g� I3�*�:�^�OX!���K��+Nvk��X�:{ݚ�!�JW�'Zj�� ���څ��Z��R�9�DO�K��0�,'���n	����zW��k��k�ea^>�D�nUx����Zd�iá���R�RK�3��T�Ggb�):�W'
��ah�kU�!+hx�tO�
���N�u��B<�B*w�7�A��M ��T�^Iά-�s.4���ڢ���I��5S���^��c�&v���~h������JpD�I����>�w+���ѡ[���M��|L��oQ��@������H�C\��R�À��j	�ُ���t��rj}�����-+���q�E;�$[{QU��e$ᘉp4X��ąF����&)��,G$P�T�.���ս*�����/�q>���ЫP�����51H'���c;��-�u�f���x��L7>gk��8c�q�	����_�[{�f��k�E��8��y�r���&�%՝�9MN4�]��b����.�>�zQA��=��Fe4N�(NDS@(�s��E*f4,�T�l㱿�='���_����IQߔ��M��Es�Q7�4�iq1H.zK�f3���^�NB!u�Q�P�Y�_'���QssвH���C�wW���'o�P��᫴׿\���dU*��^�^���G���.b��8�凌��RE���;4�.T��Z!=u"kϽ�U�u��=�>��K�pJ!�	�~����4i�F!�Q#��+��Lٳ�.9k���,܇���྾4�lV��	�Ƽe�`�*|�Vq���ؗ|x�a�I�8����q�,�j�ih��ޣ4WՊ��H'��4
C;'Ӏ���NRo�;���%H5R�yU,�� ݫ�HEWܑ����)n��9O��A��8E	��i�2e����4��#а�EW����|HlUΗsV�&)-���T�c�T���R'��Y0��EjP��F�N�kdd�J�j�`/�#)�t8���=<�$F���E���w�m�Y�F�9�?�X��]�S������O���nԮd��9�]I]�u���i�|�H�&5*������x���O�Ba[���F�T	��A�){'��H�qk���"/�4Q�����؈��;�NK�?��:����9�{Fa}V���$L�/i����u�`��
�ȡ�Du�(��Z�G�+Ց)x�&��	529�]�)@�݂�s���`��C/�Y�h�[��z�t�����el�U��n��ܻ�m�^�G�]�p 럔�ňf73%WrޑR�e���G9+"�$��C�b-j������T��ZW�S��=��QC�&��q�9�fr��?~�n���*-�T��~�L�q)�<� `�a��i�V�m�آ9�ט��٘k���yi�+%B?eվB٥@�)�b(�Q��h�Cy��wՒ����g_����ޯ^�Ǹ�_��=�'�+�w�
��(5���������r���T��s�^�vA�����P����l{{�x�������,i=�'�͝R$d�.8�z��֍�F�ǉ���h�eIهL���|��]�f@kG:�P�:�����g;�7�>ú�"w�(�`֎��hL�:��f�Z��oi$���`�<������i���EC	Т�tbN�0�x<���?��U�}�/9�k!&��'� �����r9h��X{�Ǯ�K?C��]שF���J��]��X��:��U�jr�X�G�L��Vq�}��(�n�{����oa�S�{��:������o�/�^Oҍl.��xM�J�qs�\mZ+��#�����i^o��R��DB�t�^�4Z� >��� oj�%���T�x�?P�!��@����oB�­�gX�Γ⧘��eb�]�:Ϟ]�F��^%�5|����?2|]�sY��6���.��pܡ2ˣ�2���<�.����fp������s�&�jŜ*6����}��"U�k������6�����K5�ը���nTl���̥���"��|ކe��>����o&��~��~�׀~"M�}S�q��d(�N)Oo<�,���<�a�TN�UݵȖa��QO�?߂|ǅ���'�� o\��I���C���?\�!��j���߇��M�ͧ��p��ᾂ�v��S���*��}�6͎�&��js�֔���\�Nj���]�Jj�tΨ�v�WYs�������tuPG��8 �4���	�E3�\Z2:�X��[;2�x�zs�q7��:��w(�>��.d���r�'�t>�y�ZPsy���*?*���]+���� mn��	�H�>|�l\&�ҵcC��³�L��L_�gO��ƫU�� k  ��,걫��0F�֓��S�8^%�������[�'>�eB�!"����&�F-����-�l��>�C)��БZ���ߛ)
Z�ׂ�5R�P�)H�{g�Zqy��E�X�D������:��i��8�)�n"?�k#�5�J�R��QM5\�x�>�w/ۨ4��V����>��6��=�ųu�iSN*�[ �u�	t� ����'�':�;nD�F����-�b,o��$�u����cj�h2�2�D��J��Ij_���K��
yo:.�cA��_�9�V7I�dߛ��M�F�;�_��	8`cєq��V���k��"���WȻ8<�,k(KO:0��v�;�[�$���,494:)z�����/��h�!R��,�A�z��5�� by���j4���m�3�i�I#p���G�]��WЭ+-�`���J�9&c6OR̀Q#��W��P{�ΪM��'�V*�Y�7lmh1{8E�w��h��.7<j�g$ɳM��S_f�),F��'ItX�}mγ$��C�&�~��CXohZ��f��8"m��uV����(��!^�J�z���8|k��tXop��z�յХ�
�:�tIRs�]p�·��z�l�;��+}DxZ����ė6�d�7]k&���д>jh�O<I�Bq9�Y=K5U�5�<)-�?5wJ|�&j�{J��.w�\����I	Xf%V�N��;$X�ٞj���y~|�ǍVi�'��=ڵ�j���4K���л�*����,�%���ڷ�F��f[o˗w�mΤ��/�s[8h������;:i�cݺ����I��[E��4��ݡ�����,{V5�0 7�h�]c��6ɩ�
�j��;�$s��Y��,��lO!փ|)�L���篡O�����H����0ާ�j�5 ����3P��G�Q˛B��H]�uuXC{��z��R���+/N���[��A�=��DQ�1�g*�[�+����|&A�v�Ze,��ؼ�O$m�*���'���c�h)oP�q,��Cyɇ4O������9T�+�6�jrz�|��T^���07�oE�톂�it�z�
�ܥ6��m�`�ك��Qώ�[���$�FI��z���$��o�)�GL�/��{�fe��1m6*�U꿣�(���Gk����\�aԀ����1�Dwr4:����9�]u�Z��-��=:5�Z'E{M�ף^�
�m#mY�ݩ�{o�FY^��v��O�%$]|��F.'�/�%=���֐�˖j]�UcqGE#�mU�~p %����nE�XM�t���PM8������.K�f������}��#ͩr�(��Q��Ơ�]�����v���兺�RX�>�>�Ƈ����>��[Q}��W�~?�zr��S�a�*��ڋ����~�a`m�\:h��&G)�Gm�e�ZoE5:����ά�3z���yGyc�z{��9/�&�o�-v�7����`D�Iq@%T�/j�}w�)�3��+�f�k��;�isW=����t�A��liJ#)����$kbo~($��Z}���ѩ&�w��c���}��`4��!y�U5�t��hvFE=��\��Vvd6���<e����<3en<II���w'�"-�=���A�P&�֝.��N5��-N:Ep�5*�r���ڦ��0�nN����U����?.Lɗ��I׳*����V=�w�D(�V�JQX^T����H�5%-���w����Skg�Ԫ���Zt�M��o)�����[+cx���N�Vx�\�X��m�Sz�@'���(�/Ow���^�{w�l����q���O��|��5�>i��P��Y�z���z�|y�c��;s��PNj�������ZX�F�ŝ������oHɚd�ڇ'��:2�̜�~'�	5��Nno{<H��t�%�!%����]Q�9�?iĕ΁9�L'�S�U��
x�;;P�V�N���"���ha}�E+\���>m��|�I�����n�O����N��2kЩT-��-V��S�u��?�U���~.V�������M��`=v�.|5����兊=��փF8{J!��X^�C����Q���h(���gG�8��彉��B��e��B�η,��.Dt��C(��jho|{sˢ|�#����7MB#Q����tZ�r��Ns"��:=��~������t      �      x���k�,�m-�{���pߏ9h��u�l9Z�{f��Y$�����շ%m���*&  ��������/s���>m���_��z}���~��0������z��ʿ̯����y������~��?�0�q�'��1 �)E�Q��^r|�W	�U��V�5�k}�l���8��W�ˠV@�7(/��?������^��CPr����g��p�Rt��_���J6�{,��|}�]�)��=�gv�&�k�i�Π�v�p²16�_�z��Y�.z�qٯ�n/���z�n¾�&�
=ag@�',�U���E���{ԫ����v��{���oA�	;��O�	��^�:�nW��Us��d���ᕟ�G���ٿ�-���u)�
�z�{���Bx=kp/��<cx�J~(>�j�u{Vw�'�U��3WW�w�v��x�g�jr��@����\}]���kt�^������w�PkI2��{����ވ�w��[����_�+����`m�9�_�W4�,��x��Xc�)��M�����#�^tj�L(w����,�-]c��}0)�����[��ys�e��a^������q}:8��b��kz�<�zJ�7�t���Ē���g�_ U�
yp΁LX)ե*p��_�X[^�nQv������k��̄�P5a�P�	;z4a��Pc�����|/�g�[��J�!gM��95a߃�	;��N�)��	���l��z=���MN��S^�{����zݮ�@�	;�BO�Ѓ	Ä����Nԥl�B�K��l^�����;e��P5a�P�	;z8aI�}�����3�r�Y�����t�����׹	�t��3(�=��\��;���cv�i�ל�7�&F�+�{���%��4agP�	;z4abQF��/}<���/q!��obS�`��\��۩	�TO�)v�N�OX�)�_�_�U�K����rkܫ\"��pׇ�Ǔ�-�<a'P�	;z8a�˗�_>�_ƾ��PE��r��b���('w�נӄ�A�'��ф�������)�W럾q��7ٝ�p���K���	�TO�)v�N������/Iξ�+d�_b��o`s�gq���}O!x/�1��/�g_�����>������2�!diB)�d|�Ÿ@��y�������?���F�$���q�~Y-+f'��=��K�VK�����������?���+��19�k9������ߟ��㿟������%�ߋ7UA���ϛ e3֨�g�����x��%�~��s��4\�����~tUTR���
��(%V�����鑞)�.����˕���=�v�>8g�59Z/S4 ��$�-�l*��-�l5��:>��D$Y.��=J���o����=��o���z��������l�mwW�=�$��XB�3���$�SL!U�\E#��"n4�Rc}�)؄��Ӹ�I�ey�.�g�9���b�ӟ����e�>U9�ɛ_�W(/#��\�<�ky^�ضV����o� ׉M�+���8�q�l.�翙�qŀ�p�ZeE{q��-���߳�bs��$���q�����!�d����y���Ӏ�ɍk�(���z�}��#��cтQ�S�6:�,&���"�i$����J{Z���d�D�[+[��a%���lߔ�p"6��JQ�xߍ�Scd�*���,��\L�h�F,̐�ٵN�M�X#Wq
.�,{�E^0�/M�Y��T����D� �qp�v�<���flр)���3U�X#r;�*��j�J,��ɏ�^� ���������� j��Rz��y�����/�b<m|>C���Q�����%�&��<�&9"x�
� ?䯀��g.И��a�����<�*州B�}��fǤ�覘�����VH��d�g�V���ܭIT����������ܙ�L����,�]�{r8b��e�7Ɋ1X��ۨ@���e�Rv��Ƶ�W6������K�$\-U�-��홣�-iP~���0[
�=w3���&ٹ!��ce�Uԯ�h�a췽z��[bq��0&�^�4�NU�2UL�Z�m�UV6���,�A���:ڂ�S�؁�1���m)Q!:C�H�dY�����!֔|P���Tį��i&���/(V_���?�v�wȪ�e�{@��ze��I:_:��[#�f".ݭO�0��zF���B���ަ6���E+Ì�~��66B�m���@י3�Ϝh���;4FT'���dH�;�y���9��NS�oW�<�{�D�DL6��D[���a6��� p�@�/8�r���p��tq�:w�4��wA.�(���-�{�DH/��r���Eg�
P�|�hY9{r�m��+�T�5�^b�[��_��9q4}����N�}xt\���I�
�=o�
�D������6���������@P����E��9�
s��q�����5i~C�mZ;��4�oeWfWJ��KH崝^���:MN�R+��W����-?oFܵ��� NN���}�׽�Ւ(��kF��R�W�G�!�ɻ�_�O�r��X�����~D�^d �R����&�1?C4��zx�Y.o����3��i��.����w/<��q�eM�V��c]��D��Xwvrtr�U��юgqC=�x��OV�B�kd��QMD����{>#��B�hS������\a\�������U��hl1&��3#���$gƢ�j&���I�͡C���B�n��@�3o:N����T��a�3�M+��ZI����*Gw�}4Qj�"/�.y��,�z-]�͍�����u~�D�'/6���%����b֟�R�6�V�Ӂq~���Z-M���p�W�D���۹"��D❊$��1�<�H������p#rg�O��r��w��2���ܙ������;��1V�.$qM��Z�
1�n.f�rJ�\��o�b�?�����h�ֻW�;�r�~�5�uщQLi�����;�x�[?����~v���^�0ӝ�� �E���'J_�l�w�[o=�w�ʺX1��ԝC~O݄��r��ԅ4��7��l��f/a�6l����̝�_�N��%��(�ı���h��ܥ�$�1S�\!~�4`�$�	!����=�B��O�"+�!e�'�&���ݭ�D�"��� ��ǌ��#�L;��"n�X��� ��qX�<?�|5&�J����ƫ[��1�e�|�%�Œ�I��1kvty��m����.��R�b���;*a1X�ŷr�4�����s�}'�*�y�����Dd~X�+"�fqk$Ɋ�&8W^�l�Y[�3S�\�U83w.�*]��@���3z��,�-`��%6@�� EA.��33�I�Z�HMb�1�i.�Tf���_�0�I�)Ki���{���X Bp�^�=N�����%��r��=��'��Mē��,7и�,-�C�F<ƍ,���\|Fm�Xm�1!W� ��n��������b�s��f���Q��d'����M�.rJ3W-\�ʹ��,�T.���Y�{9$3v�.5���=�+z���R����q��>�JG�:�^V��l���$g..�8�d�Nb}()��ƿj�ڐ�Hm�m�V���!*M��2I�z��'Wa�⤦,W��Z)0�N�vE���O�"�H�zwY��_#�����?MKq�W��<�1��Z���	;pY���l�l��Y���uYV��t��o��]��S��"+�:�=�7�<�C7�?��4Y��W�F�%�^������
,�0<��5�h);��-����M��[\���?���D�cg���%i�Ll�sɔ+peG:e�5Y�r�S��"��ц%"]>�N��˧��:8�!�%(��&���:�JdNĺU�,҅P{V�%ھJ���������-�R&Z�Z�BDF2�H;�+�'T���_��y�;��t��;�k�( �|�?�N*�[јbIٔ�s4`�����[��<�8����"�/0Z��L���"-�ǹ��jBP�DN�\�Hf�#���})���;�El9����r��2���g]��rJ�=��    5����-<�☽�����zu�Ŝ�<�-��ǥ��ߚ���)�:�}js�-r(bJ�I������C���b�QV�B�M�%��LkVK��;�ӣL��2o��c�L1���,#�oL>����c���U�T���f� �H�Q܏Q� �H|���CĴm�:��	�)Q�ڋP�/�쫼z�,98������d#�{�T���O�H�D��E��8���\Gʤl�H�nnm�Rb���?/���O��@|v��K�-�M�r��(��v`h9��k/z�����ȿO�+_�A���7/7oՆ�xt��i�_V��[,\�}5�q��ݟ�9��� I|���� �l��T8i��5_��d��s~�0��SLʴ�!��iD�`�A��\��{[���g���{MԐ���@}�«r1�x�' Z���pbx=(*F�[Ӡ�1� �&�B��MV�$Nvk�{kL>c�����]s/�0Vv��r����qY#2�)�sB��+%e9�(d���$-MٟC����
i����u ��x{Dֳ�[��P�m�K��A#f�>gĊ���^�F�L����QK{f�TNk����V?%�9c;@�;�H�f��q�����������9���[�a��kれ�Qy�礥��a����.Ҍ?�ѷ?��.�ڙi޸s�";���ao������6���I��w�lnTY�����1��L�fFd(a��W�����J0c�O9�c]W�(��T!���B4Z���u�mp�狈z8��ҋ͝�m�
�D��)��̛�fV�R��9����]���
C�h�J�8|~?�SP��@V�S�X��μ3Z:��>�M��<�q�ͥ�ڧ��P
3�� r�@.�@�k�,T��LE9�Aܲj5 s���$9�]�����ԧ~Y�{'�Ѥ�#8MzFeǺ7@l�;r�͌dҀ�4w�2�7 CЗ?n}�� �
T��
 3z#뵒�黧�:̷���9�����꟨j����ªby�::�̔+e��k��hɓ�}Kd�g� wJ�%�j2K���6�x�:��?�'1��p% ?�iŁ��<U�RT)d���|Fh�k �4�Oaţ(1�:���)�t$�P�M����Pk����喘�Ǫ��5�}AZp�V��a}�-�UQ*��
2po��q��z���>/����!�Zd{d���s9%T��i���l�44ń������3���\���L�����91�@?-N5�-�'����fЌ�~H�N*�&_� ��.���B��t�\��~��[)� .�23�"O�F���Ng5`�c8��ӆAܶ�'�X�~�=�uk���.1��W�?�KG�OzTYK3'&��Xp�oWƿ��U�X4��E�خ��0�4��HU҉��#:Ft�L�NyJ��t ��@lvo���`�2���d��1U�g�"�1;k50è�]��4��\��"C�r��U^|���#h�	�����ϋ�q>�a
�gn���R��	p�o$��hd�*�j;;����4�s��L c;M�R<�]��3E�~Cq������'?���OJ�mi��#]�&i�X�ik'L���	��Zn/�sM�#�(�.&���#�K�ԥq� �0�Ͼ�I��%��"�(\�$Ɗi��ގH{�6�4�*�FK;B��1)9Nҁ"����P�̊G2V7�xp��.��=nq��Q����ያ���K�F�g��E�k��x��d�M��S@~�f6v�;`�f�^e�2v ���,�1���*������v.�q�}�X+wRN�2ÿ_t�"i1���^�]R�$���M#�Ñ����N���#
�E��սK����L<@OKUґ�juLK��Ҥ�h���7�,�_S+Z�
�$P}�F@n'��nSC���e��5.��V 20���sn(�9Zb 9��N����E�i�N1���}�
`l��E�91Q?�b��g{���̖��)�������'@k���������6��]bDձ�մR�	��-���KX�C��x��
��dǠG�-s�tº'�T#��_f
��E�'d���D,�	XZ]�g.��m�ek�A:�M-]ˈ����<!�pfB;f~�-6��Q��(j��w{D�]�T*7�X���+i$�Ȍ�Ҥ�=����mߤ�ň�I3oE��7�A�����\/(��Meʝ�s_��T��q�"MW̥�޵�e:]o������k��0j J�k����x�@mZ҈�0��jy��"KQ<���f�����ɖG��.Z"�����z����2lj?�0������\�7�nm����9ݯ��{��u7��Ew����4q�Zt
l+�;��(���w,�����:�&���9�3n������;��QzI����w�whur3�T�Ӏ��� ?��X�;��������΅�M���������U�4���A]���-�������JC�r1��|��Y�|y�,n��Meq�.�O��x0c�Ynb��@Ť�(\�M��Ms��oA�ę8�,nС��Ő���\Y�f�C@Ɩ�Ã�bҸ�?&�w���Xu���;l=�j���*���#�aep���7�����G�d���pA��8���
1Rg�d��9�c����0��GUАN�9�
Z�j?��3W�x\��ۃ��b�)@��$ �;� ;b��|b�0�k��t��݆ӎ#��a~�@9�)�7-����@D\�D��K.��P�{B�U83�푗ֺP{G�f�5۞G9�z���b���ɸB��r>n�Cz��1�=�&��|�CӤ+��Z;�8���]f���A����"uS���a>�$;���O=`�_�#����iF�;��e��=��"���mL�^��NB;,�4��,"�)nA���x�)n�����-m��\��W�}!Ҹ����^�����g�]���|�Ir��q��ijG퇂�;�#�D�P�B�!�]�"V.����U �@��&r&R�ͪ��b��d��N�9]F���v
10��٪�9��*p�fţ��E�2�+���et�3�v_(ә[{P�� ���
\�ExT�H3q����&�o;M咊x�^lʂ�=�̆������e�A�����&Z�=������f^j?�Yb� 䒬��ŕ�(�O��4�\��1I#��s}ڧz�2k�����h��*&�7)U)�Ó}�s�������7�z15.y�C��BB�)�1˨�a�He���j�JrL!��5�ʔ�����d�����$��ʖ1x�0���sō�%rq�PM�E��U]u.H�;@��yo����|b���b5 �B\��"�K�o�gq�3���*Ho@��.�b%Ӑǜ��;�ں΁bGCS��F���R����3�
2ɏ��ǆ)�Z3�t$
eMrk!u�;#�:���5���d���W�#����`����$�ęl�U|���Iy&U��aאַ:��"(��\��=����4M�b���f?�ʈ�a&����V�4C�f�g��ĩ�k�f��ِg����Q�I�^��8��҆6#�Ry�@q�Ѷ��� ن)��&ۘ��"�������b���b��A*G�jD*���a��h
�8"�}ʶ�Le���&��#uԕ�l�˼�S�g����TZ&B\�?v�|D�{6,sYsB�'}�(�5"�Q��q2-iȣ&��p�L߿�L�Ӓzk���LN(q��c�w�|g���?t��K��)�?b�G�T�t%����Q�#0�\s&cjK��/U�}4}�ܘC��%"R���<�]��vT�H'z\s5�"�<XL�B���o�e�2�K��h	%���5k���iNr-����P��EMJ��B�4���bMcZP����/Ƈ$���D�"z�.|4��d& zT�H3ѣB�E�2=1���( ䷌I�����M���dV�,c҂�i>bLZ����#ƤE:�_��ѩ�,��'���Z|Q����5 �=z6�� 3G�(�ڤ=9�C?ǡ�!�5��9�0�97z�6�9_lAĳ�jF��� 3��z��}f����i��8�k_���Ԩճ�������^=ǂ    �0�(�Y ���u��Jm:�k_��g����E:2����Y#E��L��=M�K�=P
����u�G�\N8�f�|M�IHZ;-�$�����ΐf�H���Ώl��
b�l��%7"�*�<l�C����,�L6���"��G��4��r�~�z�`��+ZTQr�pAh<F��%0X������o�.���4i��_��`�=R�ә0u���s12�%�i;�y�N����#���(G��M:1>��#�"�d>��mԾ˹E:�rK�/h��IE�����`a�+NR.6��\�Yk碥��<�s�ڹI3��#rY:@B�����ή��w!��䐜}�nȁ9xGOً4��y���H'f��s2r�� �q$���\�&�&���ɏ$ j�}��G,,�gf���e�f��XX�L�0iB�R�,�HY�[�R���r������NR�.�L�.�םҹ��ڕ([���Kf�Pƛ�W0�Nrd�6�°����4��a2���=i��r��> �nM�/fП�S��A�ce� ���&����	8�2$��H3�tk2zt���"^
h��5-G����#�8�����M�Ƚ�6׉��3��j����e�<NYF�w���.1m��OĮ�$NN�%�[E�K�b�%2���I=B�K������
919nU]߃s
�L[=���nߚS�2���U�=W�ta�%���x�4�/9ea�������#r��N6�Ns���)��q����T��A}ؠ�B����(F`����xڇ<��4���z&��d���q��q���N�O�7}��o/[�'庍#����%���(*#��4��=cZl虐<�" k�I:��t��Y��E��Ƥ�z� ����m��q���ekh����G�N�
�b��]+�G��OL�!a�X�([,bL��5x�c
u��	~8�Q*^_G���'�e�>n[����� �?�Im��YU԰����4�cJa`��K�8�ǹgc�Eb%�'��,�Z@�lFݗ�
�8P
�٠�����y��6b��%�)\M&V��0���Tz���?���@2�!��f�{��s��I��b��NW!���i	l��?3����-5�箜�rgg�g��i����{�҇Ԉ��5��ۑ�~O�چ��j�r�+�D��B�D9e��뙮���ý,�b�y�r��_Og�u{P�l<�	�թ.ѩӀ�A=	��A=;�uǹ��BO�X�
�Q���2��eT,��}��"�=��"����Y�\2h#ܱ�C���;��E�_�<J��J�n��O�IȜB�^�}�8办~k���#�S��w��#����B|>�٭��]�{���4	�����0����+��#��d��T�U��Z��4K�O)v�Ʀ���W;x�[@�cל�õH�i��m��>�V[`1dz#��L��%}�xl���P+.:�~���N�ΆI�r��Z���!���烰��5�qW9��+@�%�I�ZE�������?��ߟ]z� {-�BڹL?��-���q�����G2��~i wT�`���u���y��WA���T�c��"��v޹ԑk�H?�l�y��~8��[��(�e1'���mWl�E���x	�c����+������@��ٽd�4h:P���C�to��y��E�:qÔ���̐7��k���e�T��}c���-Ǆ�dt�ɈF��m�[q��V���H�\D<M��C��T ��*��ЙA�n~���>.C��b+�N`K2Tcb{���/���E�m��d��XVg�Z`�gj�4=_�U�W1��2��h&��)�hʍ��v-�q���?�P{�K�l��
7~ȯ ���I��GΎ�S�o��;�>��������T䰄���C��#g�9�6�4ۙ4���1i�weh-��E[&�e2_��9�k�&N&�+�gu2ӿ�6z�;y-0��z�O���a��6Dd|e�؝!�Nڢ�|���|'w�dj_�fLEe6ec9�h1�Z�����LiNL��6��\D?�M�3���#7()�g�/�LH�����	�r�:��"�TL�9����0�i�Oe���3�,��36�NX0S�p�	k���V�v�[��9�>ͭ�h[6&G��(���e�R'�n�L	��VZ2C�w�Jk�fx�Zi5��U����R2��bj ��|)՚�Ռ�O 2���sv��!'���j���43SG}�i&�rʉJA-
X���r��4�$������d�Ղ�h�9�j�f�F�:=M�)v�ڧ'��a�m���ˑ�%S��M
�������F�!W�S��i���(yl��6�Կ�ľ��H�5���*p�C�ՅB�a����qK��l&ӣ�~�4S�t��o�f��&b2T˽���)S�����Ap�J�jD���Y^�:s�-T���L��1/Y����e�l��M����)��XM
�0�ȵD9�٠+��(%rg�ݏS"y�/{N��31���8b�.ո��@ܯ�Gˏ�ƟΉl� �b�����8C���oH�y��S2C�-�y����pTn�\@�=�2��T�9ν9P�z����3J��so�gJ�g�=�V�bW0��W�|�j���S�٨!��s�to�f�CҽE���:&�k�!�V���넼L�t�������(�K�t���p'�n[�@S�Q��&n)��[")	yJ�Oy���1۹$�ޓVY�v���0��m{� S}�t[���8S�|������d�+C�-j���}-��I�'��Ib�:��m��@3��æ��8eP6�]��Ok��afG��y�ݕ��s�$C�/�Ȕ���X�+���*�x���a��"O��Nkm���܈��~aG��Q-�����d���U�q��Mq��]^ę��q��E�k����x��/9�!� ��0�0V�'J�/�U�������,?�}��R�Dq�(ъ���Z�O����4vhчHO
�!�\��D��o4�+�T�-[dc ���P�ړ#p8��I{D��/}4�@$�� GgG���|��׋U�3l�f+)Q+�)��r���7��̐�8�2�s�l���#K1͕ gfa�\�&H��u�Q���1â�\JN�q��ѝD�3L�"��az�%nc�?�n'"�r��~%:'������_*� e����2/HUt�/Q�X�Ӽ�$l�]P��O��Ng`�O���<�o�?=�#_����u���^�5%/��9�fJA(F�['$rѯ�����b�#7�����Zb��\ �xBQ�Hf��F(���>3]5�Qs�r�=&�fF�b<ik}��6R���ĩ��ٕ�ݮ�|=���o��ssF����vu�r\��E�yr�詼�}^.˓
�Ũ��:��]�:iq��u��"�j����|�Kf��3.7�d�p6��+!k3�3���vN�$g����
���rne��TU� ���#�tAb"-���3+ȑ�ZU���q����������3�v"���vkÂ���ƮBP�	 H�=�$"��y���ͳh�a��#����:p[����=��kd��Y�(����8gk;�!��0�d�-���Zr��shwq69�~0�*$V7Z����l1N����A���d��g66�MO��~#}���F�U&Ma�7M��Qf,!�Gw2�V�SO�ۖ�E.���Qj��{�o-B�$�أ^��Rd�d�Y4ȮE�],�Գ��%�S�D<Pͤ�j&l{�f�p������Ci�V����u-��vW@��J��,w��!�k/�'��6L��)��-3UP���8שSe���g�3�-r�����]2�0�"�"�,��[�EۅAd�H�D�T5�BV�s?�l�� �D߷�|Lq\T!Wt�<wQm*<�iL��	�l�C��Ek�������.sX(E܋���Hp9i�5��:Hv�9�G�0�W�#��Y��|07\���b,����Q�ߖ��
ƒ��?T�j�t6��|��<[W�>�JF��I���:+:,5e�Gom����z2��P�,��5/��    V�D�����R�]G|f���0u�|f�W�A,[�)rے1��'�Q�{#�Ȑǟ�ȸ 3-�;26�B�Qvd\乹��US���Z�-w\�4�
���!��s�q0Cnu�����̔W��\�4,�l*MĄ�@a���έ�U��jV!z����e��2��zw^ĩ��aܹ�n��W�Q�z�tM�ŝ�NS2h�.��'$7D*}�T�y����Q�y�tP8���cH�ߟ�N�S��*�ܶ���V#&6��z�EC�\���2u]�ޏz`�0�Q�(��Z�Sk=il{�/B�[V	��$��`,k@O�S�0�w{D*��Siʪ��xi�J%�D�)}_{�>�����T�n���h�� �<��I*2�v����#u�>�,�Ti���c�<x�m���6x>�%�hHOe�LsY��j�
2-N%u2�4y���β��.���2�T�s���.���d����}�H*a��K[CNL���K�"N�ۇ/m�<u?G��;U7��cX��%d��ak]>�ƌ �:�G=!A����C�y6��L�c��W�5q�Ѫ��v��l�L3Y��F&PG(&Sj��qUv�܏���F�ȁ�N-4�]{�<��u�Xɺ3d�J�ęRt�ZC����SWF�tv���I�a�I�ݶ�th�����P�l�A2���Ad�Ժ ��\�`�ֳ-ȁ�uuם���j�dU�;ZD6y�������[=15�v�$��BI*IL=$)��t��G}"��BD7��9��f;q�e���&qng)�=:E6y�M��Vjm��+r�+�ˑGA�FX�"uu�_)�(�h�d���dK�*�n�)i�@���G��&�0��4i���5p!Q�����T�����T;�KC��ȁ֎r}<:�5Sm/u����>ݰ�w�m➹�Ҥv}�U�ѿ��.FT�\�(S���5"U�p����ȱ\\��.9@S������}���$��R�+a���nS[B�D��_@kD�@-w��)�FF���B�����̲ ��q���ݹl���mrE�_��n�<P YB�H������
�k��?�ʵ��ӹ�HnrK4��C=�e�,���0͇KyW�6$1��)��yjx)Su
rO3�����]>�2�
4�rm���^���=%s��#ꆓF�,�n)��/v+���Vqt5��J�X�Rw����N�q��%c����}]�h2����fk��{�����]c��&<�G#������'�ZI��\�f{�KI����3g����YC��;y���ϊ�i{78��kO��W|���a|�}}X����=�����{�mN�O�+zھyhVD�!�"���o�p�Ƃ�2�;��(3��bo�����d+���:^e+�ٙMu 5�3H�;���5r�S�;3X*	��z��}��˶�
��]x�p}=n>֗x ���u���N�����h��<�4�����{��1�ϲ�q�bW��	������s�$��6�O���iģU4�5�8��ۃ�BN�E^��Z����&g�v k[��vY�9���Q0�BD�w�p�ҕ� ݵ��5g �;K ls:�I6{#��ۀ\ �a�9�rg "��[��~3��N0"n�0������%� s����֐�
\������I���[x���x>�s�r|ޏ�"��H��Q�����y��Cנ/��`���#�~	�IKWb\�!���H�Ț�>�*Y���|P,��|�*. ��/۬��HJ/_��o��a��Z���29f��g=�Ԡ�HE��&�`���/\�t ��L��̐����Ҏ*�cM5j�L�>��猖��L�'�h�t����wW��Vra��H��6��.T�.�������21�Gᳵ��#�@��-�ݕOC�ħ����߹�^k3Oa=��s�t�b9$k�4/v��"�R���p�����"_㋨�ܙ����������u���3�1;MV�';O���7Hٍ��.r�v�_����A:v�:i�L�IAyt2_�6??�������������"~��s�D(Tq�%I�_���j�¹�Ŗ=¹؛O�$7'����w�;��g�l,u�g=��{�!�k��E�g0����5`&,�Oz�) �X9���X�:������-쾜C���hnT�yq_��a�>5�w�OvZ��5&�,T��b�zbJ�]f����F>�43o�ĸ����ѡj=,\��J9���E	��Տ/QKS����@���i�ՌqU�)����QES��*��)Ҟ	��V�h��.?=�H{&�#�:��{���w���"g��W\�
�1$��
˩:������c'�E��ji�CǾucߊ�c|Ʃͫ����&C���2(	��r�8!hDOL�Q��:��q&mɵd���P�.���4jS�~�%���q��W��ix)˦�XwRWY�����^�jSHf�u�@L��a~~�:#W
R��/�yӈ�2�����ueD7�?�.Ȍ㬫��=
i&B������B�ҿ=x��:����Do�q�(E1�m�W�F��^����(3�=ߓx�)�˚Q��Äh�u���&���UA+iO���j�tA�pA[1�s�}D�2g�hS�T���&U��DO��S����i�8!��4�������B�X:7��RkB����s�B�(��#y,�w�����swG���x�T�w�F��?�p�G`����P�6S]�0��y����i��k��A-Αʏ��ٔ�������
��ۻ�����u�2��)�lΩ~M�U���V�F�S5YY��8�SEYy�ݥb�#��(�����@}���FS�b�H�?�X�'��S�z��Eull�ܑ���L�r����{o�ѳ��M�������Pܚ�e�o�}�+��-�|�s��Ԟ�� ����ϩG���\>�X6YK'�'�c�	-(��2m( �2m�,�H�+w����%�[6f��&˘���d���:J���hH�y�ޅA,L��S@Y\ЀL��s_���	83�i��dSE����&&p��:�̜b�̜#7�=a�dJ.�tdJ���֭d�tf�Y���&i�E�i7��Ѧ�iqH�rN�
Q�ɝ��c��:}P&�m[�/h��� FUD4"x?�S]0�S�W]Q 3�+�N�Y-ͤ�Le�2��ӕ��& 6g-��*�_��;=HR ��wTe�ΔM��G�;gF)��✒�����+�8,�f2b�
��S�Q��*�
LS�n��J�1)�:e2Z>'D@+��G!��=Wd&ޮ�KG��#sP�eGD ҌG?��{��$�(R���N^�L�&� V\)�(�q����Z-(�3ZSe�_|xܝ{"��_�#+���T��#���0WN��9�E8F~߼#ȅ��2����w�'�w�D��y�ف�|���Ј%+���Y��X�a�O��e�'�� bl�jzE�z�=s^��;�MjO�vt�hL��܉��M*��r�K�{'�k��������^L��=���K�$Si�#�T^�G>����؞�}jK� ���0�Pğ䱌��&�s4��;�X�#_�:%d�bDo#	9
2SE�����!r-o�F��)�V�T|u�S�0O����ԗ�3%X�LQ�q���(֫WQ�h�ңE���$��Ћ��ߜ��6�x�d&��;d��#S�[�8�b+%����X���+��X����А��Z����Mf��2�TW�4�/D<R�GE������Y�Jp5�������޵�s^��J�F����`���[r�|�Nl'@�4�~(Z��GE=��P ��R>e��0uL�8Y�Z�]:vA� ����9J�$G$U5�5.#�-�l�qb_2��Pt��$N=��2�Sl'e�0�K�����u_���39�� ��^��K{a�1�Y�N�� �`���NZ��r�*�X��S��Td���QsD�2��n�v�d��@y(�L҈�J=Pۨ>DXCVLn�%O�-��kf�z;+�JAT����?_)�E�z��ϟ    ���EpLa���W��<_�֥#w��Yf�+��ͺx�M֙����[J�v�ݳ�-��o�Y�I#R݁��w��P[�F0a^������VQ③�J��h�<u�թY�ty`�4�J��&#����GW�I=2�C_ع���t�b����)-�5��;LU��f�󖲛��t�v����K�@����H|����;kDf�W��l�� ���d2C��"�i�F�3������|91U}�;;av&x�=�3;{�:�?B���ӈL3�q���6Y����c�w�A3,�+�:�V�j���q��so���=�n� }�)���6����:�$@2��+�v�S��"���4�h�L�4+�:�N�3칫�:�Cm���i����u��8�� � �����rs-""c���۹nQ_����)�	h��~�^g�kq��~_g;�O�#����l�;4V#��v�s$�L�@� ���������DE�Pf�a�ӱ�q� �X�N=�����OL֘�17ɡ��@�E��E���Q���H��;�E@�sƢ�p�8)n@SG���I�:V)n�&�L-פ�KO
�(�u �HА�F�����:a6�=�ZJ�ڡ_!ϝ ��c�HHfv�Q�tA�8���Sh6U���'Z�t�Ն<c ;7������� �}U�R�|z�X��W�	_����^z�A6�["=z���K#�?���#�;a&l��9Q	]:}��*'6��ی��Z�1�%U�ћ,۬��4�p���uLz�S�Hn�8�<w��fw���њ����]b�0��Pĝq�piHJA1� �^�\�R��1�&�0u:�ugD9���uǍ�;M���L�*����Q�u"��6�vd��LS�_�٢s�q�����" �������-�P�0�j����l@h��A!�)��6U²XD�N�e��f��\�Uz��1	:[�/5�H.��%����\R3Z�J�*MEo>MҔ��m�p���������(��Tc�L�.{C���µ|AI��H�c-v�M1Ӆt�ـ�`�*����F��J��D�K�$����t�����2z�+��챏)G�:�n��~{+id��IW�M�briU�4�,�)�%�ɭד�k4¶�@�TT�{_��N���:�=�&��x��yu�2�^H�u���f��j=�fi&|j<��(Ĭ5%����H��{�������H�v����:�(�K���03!3%�o��m�*M�H�mV�Ζ�(����;�٩�iy1-�<��970䯀�	sə�߁����{�{��"E$��ݭ�xvVF&���x�'�I�z����V�=KӢcR`��v��)���\+�e�C�{����'�Y�^}��'׊ek{�ݔɆ�%�������Z,A9u�O��|�����@Ncbm/�K�����in��;�t��z�F��K��j�C�+�u��),�5S��n�.'˺�g�R'k���,� fדXq�"��+�wN�걿"�d��MH��0Z�D{"��|���K7��x�"�_TG�����7c�$�N�۶r^�R/d�KIS(O�LE�5sPo{�ęF׫�a^J���_������Z�M4��!hO�㟯EU*�}�W
DÉ"��\G�"�Z"HDę/�j@�p��b%�]�Kw��Qؐ����P��p�G��5���R��{C�������eGK\<�����c/��h���b���ҝ�&��}M��(i� b�G�{>���`ꋅW;��p��H�$��nf�E,^1�і*�WRd(nT�d��*v�5�z���mAXΔ���(3~��L}����z�5�$#N���3�Aw"�Xv�IJ 9z�ϕ�Ɓo%���;#q��!?C�l尉�)Δ��(Gʕ
?*j/ӑU����z��3J�N����������"�Xʃ��+���sp̙O��QpU=�=jk��3�~���?�G.��K����8C������Ђ�L������"_����K���YoFm����4�S���d�cu��ŵ��:�Q�d{����S{�U<2<G�AWy�`njƉA��e�O�Q:Lv.1� U&<�	�)L?�tEf�·ȿ���,s!���w�"�=`�Z�)�uܷ�S�z�Z��e�w��h*$�I<��Ĝ�zߋɚ�M3��];���������y�� �t	��g�����X���ʁU�yq:�X�����9�⺿�c)b,��|(���J�i\�q�+C_���(����'kZ�'>�Ȟ�vL<��1,���"'3"�$g�v���]4i>�Ϙ�GU�X�,҇Q�>;i�3E��I�҈��t�H��)��RΎ?;4�t�K|	V�������Å���Jz�'����3=D)O�UC:�ݕ	t��"�@2�����P	5v���^	SfPn�T]��ms�w��zGlM����L`8g�����i<P4��{M�ܔe��5�#�f+^?���6���il�\�Rg���k��\�O�!��CB��A�?�ކN1����f�3Æ��,�cC��1�T�,�)���O��}�#4��>��Slˍb�Xf��ZI��vn2��� �P[%��E}�:�*��NH3�H�z-g�=A 	eT��c�V��j@r
��X�Ag���l��X-�婘�.O��#+͵.U
�	lڣ��NM(7����ޔ��ՠ9*A�z��&δ����҈�!�ŤO�m�j��H,�v}��T�r[��T�a[��"�R�xABj�<(��9� #��L�%��x�du�L��k��[�>�~<cp�f�/�~�
E�Sߦ���э��S.7�9ӓ�־9�.�<�%[KbEuCo+� E���ЉQP�����	����F+�����x�1rASa��M\�vp�����AS�A�z�W�5bP�"ͣ�K�����X��"Ӓ��}'�X���K�rf���6�Qӓ��3��|0��_�\ �\�V?����&�3|�hs��6(�Ķ�qu'�s����R2sQ��"�O0�~�js2N�
T�_�E��#M�:�G�U.�>��ķ��L�M�B>�K�$NY7����Đ/̋���=��Ǆ�Ua;�7y�FS�o��iO��Mܖ���S@Ӓ�ͺI�����e��drK��}���jP~��$_`hF�*�ű�Ӌ� 3��Vw1Iӻ
e(L�tM��bZb u2�4�2[x��Q�f���X��N��.�˃|l�m�>Q�2�Bm5�n�%�8�$��t��҅|a�x�D�kb���G+O52�mdZĸ0��e1b�9 �����ZIӚX�11�l9S�N��#hq�ת~;2��<��N)�&����5�����W"���=�7�N� #c|e��7��ځY�����4T��7���Ie������G̃咑sZ�T��O�e�|<UP�I��*/U�J�n^��Sd)��e�ś�:f�e�>�Y|7�@�e�)\5$U:y���^ms6�P�3��"И���n¶����x$.��Ƀ� ��)�ӕ�U�SL:Z�v��s�~j��� O��M8��J�$ff�s$'�
1����Ⱦ0�F��&����ݲq����~H��5���:�]�z?]��3f8˙A�v͓��S��M��j8�!+�'�\�h�*g'J��F�_�9Zݐ�S�6��,���]y�!l�����U�-�G��� �BK_�Ȑ���� �
� qi���l�:�z��I<0��J�r�ԮU���ta�`�P�EjO��ΠF�'��$$�5$E�r���.r�$nRA�%N�-Е�^��T��u�t�g�0�� ����GPARʨܰ�arH���'q읆L�=p��ŋ���Sv�I)C�L��T�v���Br�����¸� 嗀����O>j+�n�ȇ����j1�jx7�YӽpE<�k��PeQwM5�<C�T����<uD��XM�M�-�����ɽf5(u�L�{n�d'H��n�T-�.��I�������I��;B���:_��K�V�J��"|��?Dw���` �H���v�+_�+�tw�'���v{ޯ/g� =׏	'ՠ<?����ߟ�������,���#����� ��̩5W�����+b|]���j    nտ^hȷx_7����#	�=�M?��w�˷�q�VT���*q�Y.��~=_���Vã�b(/{˹�g���/�{�14��>�86�}��5D�8D��ފ+�0��;���1����f�����\2ɼہ���{�fyAt#X�`u�D�봷�Hk��U6��Z8�����j��s�|��W~���3U�:�&�Q7�j�@l�OU�N1��L�e+�*�&*Y�l�����n��&x�?�ta*����n}�[�ci���<{�E���Db�J3�E����� p���bh�9��r:�3ϟ�S�\�+.���c-�!ӌ�Q	����zn�Ҟ��u����P����N�,��m�G2����ȑY�ߐrE1���H��j��Uf5oߑ����~V�$n̳��`	�J~���=r[�,}���N���H|���dGٌ�X>��=f��!S�~�M���z���P�QeP�$���0����O�P��*2� 	-���z�[9�j�.�R_c�|13:�d��Nę>
w�� ���h��B�.Db�u<���M�g@��X.���Nz��y�`�(lW�/�7�\4v�q! �Qۇ��e��KA�B1�jT�2�,�j.-�)�O��t��M���2�m,�y��o`ߨM��:� e;��	�"S���'�*�X�q��8n��Q���F۳ǬmEFD���4�78�?����� ����H îv�X�T�;+���Ep�y�Ϛ��hi�
2�K*G-M�n'ɋ5�J��QSoD�� ��ռ��񀴁I����A��@V�ӨD#1���K�؍�f2u��w-�=^��\�����H~N���}��V�i(��O���`G�p��D4��Z?Tм1�Sc�@f8to _�t%�"��c[�tbh5��@΍�d$�05���@QT3ߥdP.��3LF��'���E��8Vt�H������!�=���9��G�R�w��M��J��.���[��h�����S<���lRgU���g��広G�:7!s�	�P��ũ<��Y;6�+�Cg��@U�Aη��N����������Z�+iH���y�:�A4��ZJgOpm���j��-U����;+j�����.I��ȡ��/���+�K8FֳA��󟛦�4:��R9�G5��6�z<5�l
�)ߛjށ�5+��D�|��$��%�(C����e�l�Q��zA�����`hvS�'�)%�i�;�pg�S��X烈��7�zB/l	.�]���U�"u:�(ip��A�%�'�`wv��qI�uL��]:�֩�n�&��9�*#`S�蹩���A���Q�4Z�QA��������ň�G��Z�{�L@�F@ݬ�h-.��A�F�CG�&��U�	iM�}E�ZB�;2 �xF�ґ	[M}R�ѩ���ƽ�6��q[�Yg5`������c"�S� 1t�}�Ȉ��ͱ�x�|�
X�ȋ	+n �EL1ϑn�zk�%a���&��ß�iA�DQ.bq;���P�������Տ�i�M�2<�S`ŏ�S�+P�V�M�E�[��hLu�8��L	�\ￒ��Z30�h[jM��[��{��2XNQf�����A�X� e�&��_42c���;-�=W�5f��2��4h.��X�&(�Z��kߐ���l2QŲ�N,�4�֜z��2*��ąm+�|I��I=����N�-��H�,�v�IS����$��6�AX���U��!9h!^�������)��0�<GM����Z�f�מl�"3��t��0GH�/����<��8�Z�A^��E��;��e1@�$�U5"��9��.�,:D�8��`�ٞ�����Y�7T���ܦ��~ j��3�u�f�L�$꒙Qш�j�]�u�<��춗��������*6 �7�9 l���[I��m���T��r��z'��C�/���R��/ʿ�G�5Š���V�� �b v\A���Hl��!�&b�$��"f	�Yq$���u�0�D�;6e@�_ �:�c��a)��i��##H����7�������
n[G�=c�Lڕ;��e_ed!2S�����}�*��~"V?�5���8�`��k�q�?_�0�~��^16�7
cLbG1$�o��w�n��x����nT� �"SR,����m��'�׊(z�[0��.�o��"^��y��S�KGC�Н�F���"���9�e��#�J���hsE��(z%G��4L�tP�hS��s`R2w�}>�>��A�Ą4Q6'�8��`� ���ݑ2�Y��ki�.LZ�ԔEE/�qz��=j��k&e{߰� ;$t^�Ujc�L�R�,Y��c�r�u)��N���}�E�6=T�hl�X�|�e����k[n�x�Mv��Le�����L֞.�q���Y��v�h��B܎	6�&�4"��H#�<;��dF�e'���x�Dp���-�_���./5�':MW�h����u�дl1��ݛ]hE�L.����Z���Z�aG�u�L6���jQ�:�)��;�%f�\��.!��ba�tH��NLh?�c��3"�&2��NR�X�"e�k�:�a���Ð��w��5�Ŧa��zI��� ��\�}�b*���N=*���̵��,��n�~��_,hL�`9�M4Q�"e�3�N�O��1�y���)�@�8jGO�&O��8�0�� ))ə��@�D�d�گ�J<P~�$>�����uձ֎��M�ʋIS�F���=��9A=�h�}�chB���+%(�ʤ�Y����(T�
�flM���������uԪ�iUBW��*�Bu�[
6^�.`V\������<�Sa���O!_���ч�KɶZ��q��M�=l#��Z?���&NM�zW��a��S�f����A=l����t�)B�л���} ��Ь�d�VA:�X�g۫Zw<*�곣�;����9���ܛBθ�w��5�������D��m�%��hQ��i��u*n����\8>e`-}O�CJd
d?;��`ϊ��7�\[\'q��q�a�q1�Q`h�?jq��҉%�g?/Mx}K��dw���	���8�j눏�r�m������!��k��F������"m���b0^!{&~5%S%�i������J'�����BZ�d�0�X��*.9A����7�롂țD^�梥=�%�kħ ��U*F({���v�a����KJ�@0SIQ2��#2�u��ƫ5H��O�	�i.[7}ge�
�Řd�2!��'��͕���� �ķb�
����
1[����εy������+2��Jy�?H3	�qh�b���S�L�5�h[�ĞӮ�e�h�RB��Fd�Y���׉�b��������X!v��vAK3d�.��ܤE7˔�z�7&� �� ��K��e/�?�[8E�	k5]�9�e��5z����f��J�t%4��%�&i俲_�̳�=���j���D�KŬ�.�~��G�+5�\��G����=n�L}@�
:ii��[�^RW�M����VРZ� 	-���.p��]aw���ǔ���u�e+�#H�W�F�̧j���E�K�����s�f�;�V�&��%�-�W�Uλ�M�^
����xP�pI��Lg�R(�A��Q�А�gP�U�-�p=tt[�(k�,j�/��;�5�m����+�7��d|œ��+2C�q�h�H��� �~�f��)Ѿ�8 ���Զ8�٘v���٢����K��=��"M��0�Ҍ��u���7�jB:�c��y=�R��i�r�02������3UjYsX-���z1��9�T�Q�8���"ۇ$'�,�A���k	�yN>Y��"3���ta���{B��L\bʍ*���x�2�9��(qQ�(g��Hd�md�m�n>�4Y�33S�J�U�Z�������O�W�|�����Av�l���P
ޜ���a�x����J��dEf.ש&)co��Ke�ۚ+0`�r�+ٕ~ V�\l�)L9bSY��`f�f�ު�q�해A�8�5d*�5��xO.8����ͽ2[a��Y�dZ-q�bI,�ȗ� >�Ղ �����2���    �n� f�#��Zݡ�����}EN��	Ur�>>�$�&�Ȭ	H�,{
V���d��j�&-Ne}+��r�&O��~~�ɚ`���^<�X$ �~~~E��[R��^��ĩD
��mq��S�Gw����-!�d��8����ƽ��v�E�G�ˀv<=�=����=C��H�K�}�yn�i~�D��2���b��t�Y5MO���et;�qw$9��+�-�(��:��D������sQLbWPH�6��6��lw_��涢�-I[��D�~C��e��C������*��a|U��u�g	���;>�&;���L�b�8���!ms���>����������G̡%d[���,�rNѡ�V���צw��"O�L7d�OI�[p�.�׾|J��Kڛ ����� ����Y,��Z�jd����%�d�hH�����5Qc�?j�Qb��&WI
�t�Ƕ������	E}��K-�i���<mł@3�K}�L�\�N	�q�����;�Uu��/�%R��gX���!g�׭ܞ���K~!���&z�zM���ӭ�rk �����ʻ�@U<��@��Y���I����p�6lqf�Il�a���$V��@
0��C�����Hy�wr�+Ѝ���/�h\��ZO���{�c˒���:��m$�x�Vǰa�9+�P����Ӏ�B���7�� ՠ�:p^bD���p�p�.�����~D���3tM�l�D$�y�W�t�����R&n�}w��h-�Pu<�l���{�4\� ;���d�^zF|5q�e�&��,�J�d}be{G�g���q�� O}[�J���~�1>�r"�t"��mN����8��2nLW��D����O)VVf_���2I�n�	��Q-6��i�@T�"�� �jc墖�H7��~���&����r�	�]b*� �*f�X�`�W�����E�90��H�I'f���d�t!���'�,��q�:ǅ��{��DQt���y��i�>�Ζ%^L��B�QZ��x�#&b ���݉�b�ȩ؂�E��������'�Ft[�k��������֘��պ��PH6�H��`�@͌��)4u�'�L���S7�<�M���:릸l/�C#�"�v��P *i>2��qu�&���?�l��1T���b���G4�9G�{�9י�o����t�@��֚Vc2%n&����kb��ܶ��,b^c .7F
I�ɣ�w�5�1�^.,�0K��44��.��zd�ysq����&ϐ���/�i�Xy����@@}3�}�y4)��wE�ƹ���0=3+�:ͯ���Q��U��;�4��s��\�?N�)>�]�sDb�V\߄��t��:R�C]޵hq�����*�P�o��w%\�8�?�
�>,�F��X���>��|������"Nq6?_���M���&�}t�z�OL��q�pq��4��|�q�:`����������<���q�-������<n���m���1?	kK*u��U��z���'M�y&(���]��*�~���#܂w���]':%�0�Ч��l �֨����|h��~���0�ŉ2�b��YO�H���qbR�t�T�2A;�ժ? <��n�������SW(�J�	,�Q��7Df"Nw;nȕ	����C����>O���E,+�;�����@�a_�&����M_����8�닂�*�rn�������ۀ��ڪ�����s���r`�e��;����(�3CL�1�@d2O�H���ʷ\iPFq����q�~˥d��5ٍ,.���'��r�eo��,�^#&;�,�a���&홼�#�&M�7g�^��v���ȸ[�aTK�N�+�A�5�q�k S��a��&�-5�����I3�s��\�a����𭉕h��������2���A���|7ij�t�������wf�������u�`����Ч�>r"�Y�b:�G��Ė<l�i0��_�6n�f��Xc���7�F�6z��� ���$�����3�5t����aC�&]�izs��q�3^�	od�P��.���Z
�QЧ9]�L��.M:��ӥISgI+�dF���2�1	���x)�\��˩
^2Z�(ʵ�3�-�!Z=T�h�\�4u�~C?C��u���1���-���-�55�"�1�08 ȥ�|���9+��Lt���.���FKsq�w3I3�>j��	]��NXK[rV��`�G��M�F�	 ��yD`�γ�#�_4S60��o���Ӹ*=�e��~i�q���\P�8��]Ȥ�o٠��К-e��:O��5̶9IՀ�GdPM:��ڐA5�̜љj(S��f�wdP!#�I�vk�U5�g���Wڵ�L�[���W	�������|c���^y��bK䡤�����F��FMQ�V�rA5d��'��A��,A�!���Uvt�*:sb/�5�B��_ _���JH����Y3�{IWa��:��I����o�<�GAo�� �V��G�%?�A@�42���n�-�:��5�z�-+��4y��0��'�g�귺G���Ž9����Lc�տ5mNM��,����c1��'/$9��^)��0Z{{g���ע닙����Z̽�^�j��/�a}�K�atΕj�*g΍�͵�I��Ҭ1=��T�G�������j0Sx5�	�hsFY�)EE7a������������/�q��� nH���u���چy�wEG0�#+;u�a�����r[mn�_�-���x�Po]r}���?g�ϦY�o��E�,���rSWgz�.vw~�(Q~�D�s����"o��c{�>0���8;@Fkpޞ��Q��AQ>�y`2���r���|��N���=Ֆv�٘�?�W�5ra�q5�D5ڜ����LCM��3���D�4)/���u��u4`9S[6MN��l7�Jm|ݶc���:Vu����'Y��nUm;h�5������x�,��l6gI��^��A��� �FI�l��ɥ���'�Ի������ �g��rc=rRt�r���A"��4���ѧ���f�Nw�js�8bN叝�/�=�ΫF�ZЀ���d�%�ve�co�'��Nco�-Ԅ�N17���������v�d�'��6!{.�Դ�KNY�eK�� P��x�S�Ӷi�R���h�D��� O�	v�t���|Ҭ>Դ��7�����mȅ~TM��4��i�;�nl���*�xg,*��h�y�@,����Z��P"��ɮǩ-F���HDR�֭��	s����X�\l���7q��.��ǯ�G��)I�����~�����H�� 	��[����C��K���L|�7�{�;	D�����A���g�ܔ0-L���S֑�i9pʏ���ye(�Μ��b_˙Z�Q[ �{�)��52|�@
߬���ގ?>�@b��������KzpX'Gd��ཐ�,l���S��� �c���^��{���n���L����LD���<�p'��O<V0<9��Ȕ�.ٲam-m}`�n����-��%F��
��?�e��Yj����&5 ��̖��4P^�e7k�\~ɖݬ#��[���T�2,��ey���a��{���"s�_�-?��]�����77z�>�on_&pB2,�j0�Yg�d���xǡVYe��2vH�,J0��)��p��v����PO��,�ZE�+X�-wU���D�)CB܉'1z�2S+�%�^�m�L+�T����W
$���S�=��kFE�A�ӱg���8��kD���^���P����Y�	����� ��ƴ*�n�T�s��c�]װ%0|��CN_p:�
��NՇ,��Dx��5wlN	?��:�DѤ�]�35H��w��X��8i��9��R�[��M��b�p�%&GC޴b$e���+�\BK �2(Ղ��L3�4��V]��
8��d�#��>�A�8���])�[	�֩z��U��Ӄ%+�h)r�(�I�6{*s;���*U��o���=��`H+Ne�$ہye��7{�ӳ�j�����S����W���׷    ����}�����3���srT^�	�O��0M����㿿��G6gE�^"�������P��s�wlF���ak�Ȟ:"^7w^��n9���|����I.�V3�m�L.S�����fK	��J��*�r^���g7�H�MtVl9>�0I�דUW��������(�f��d(9����SO���B_� ?�Sn�[�@hi�a����M�
�Ls����	���L�1��њA`[�����K�A�Ŧ�ڃhJ��y�=جw<M�z1�8+�?:�[�x+�\�|a�0P�ܯN�Ku��˰���i� ����^]m�W�c�U墆�PcԃF��Fbf������c����m謳c:%>R2�ɍ�g�ãw��'r��� �q�e홆̰T���5�&�T�i�LN��7��h�>ljfZg+�4�A�vLj5�R�L���"�elc����r$N���_Y[����A݁�?���CN+L�K��\Qy�5q�/��ѣ���1?��q۱�[V�hs.�2m'������Z����g�Dm�9$�#j"xtڜj	3*Z5#Z�}a�sq�`�(t�HD��჋�Oil��'{�)��}�H@P�a��W��}��bv�����{��ܳu�E5�^ٴJ���q�K֕��uPQ�,�땒����0�/�9��D4��x����}��	�`P�|g~��I�D�"!���y�SuA�C=���)��L�'�nҠ�)
ME���8:`_o.VS����˽���C�T'����|���A�FGE��)�-+g�e�
&6ȁ����b������"P�L�U�ʟ>~�Osуc�yBʵ���&�n�ٔq���@�~�U��%�)��|���Ε8~h/6p
�#��Ł��3-#�Mrl�C��a�&��n	y_�	/l9���ܖ.���g��-���^�NnhY<���6�d�tѥ�L�ϼe�}��s�{����cn�W��d蚘�mZ��"�J����� �%S�/,���m{<k��1�s���-�!���۟�	Qa�x`�k��xW�6��|x_�I%j��_k)r<eϰy��ك��}�$����TݗwL�~O��E�E�?w�����yof_l����/��u�įG��[��M�H+�%t��"&�$�[R~$�`F���t�ޖE�]��9���Ħ`"��{�r�����5�7��od-��=�K�>�3�;�"�z�a�����¥
}��Lo�s�z�J�2͚�����)i}wo��v��!��4
_
�7kfP�(x>RÈؘί����������+�dmV�I0�t:�vi�Lu�]i�5k�%�v��O��T�U��<���|6e�T �X�a����o���̎V��J�������J����l�H��^e�l������]�}����չ��U�J�x)�m36��J vjĒۻo�����|,�������ϓBdj�+	�2Ym���@Ά����͙�Ъl�5㖁=C�c�ljP���Ք 8��%�+Yf��xb�2D��ھ��q��19U�4�<7�vm�p�X=�5D��4)s@�I�(��b��93�Q��<��	�WϣB��=o_�D8���M�!ʔ;Iq�f� �{5B������ك9��3~��T��I!7!v�T�/�U"J�6��_���R�}͝-����V���s^#Gjo�C;is���ji�����ӡ=�0C�w����j����ӈ�g_�d�0ۤ�%�
u~X�O��L��·9U	�2�C����z��ʕϣm�b0��?��į�����9�f@R☯�(A?���,�q �	�N��dh��7�qlÞ�>��N� ����p:���%��`��dC�.��D�(Ы�d�	��2I�z[���Ru�ʣvHp�ߵSy��4~@p�
�G	�,.I��ջԒ�A#2�V��j���!g��U&hR�a��~�6s���*�봽7L����_$HJ���A8�qwx�z ڈN}-�H��EK���i!����:y5�L��<S��"��C���s��tp�N._*:�	�c���e+!¾gvv�d���U�>@����5���uCf���.����7ZU����_�mh0����ʖ�kȥ��AG|j��;��Z�]��E/��N/�	x�dN�qW���`4���C��B,�R����=<l��t�=Rh��Iċ�-}(8EP�1���pz�lC�.X�LPtO����ZM:��͜�Z��u���f��ڨo>[���t�p������$�F�)�D��]Q�C����L����Es����$�"��}��S��d?�r/��Q�s�@��|�D�_�)	9�xL+"�R�vT���8Q��'�.x��D	8����Mx-ț{����mi��d��z��2u�����4sF[��"�U�f�t{۩L!�R��R�'�X��Ŗ}�0�Nl;�"N#�z �xz��bWh!���bm�����͞
 �b��=���,T�N��;�ܣ	L6wf��tө2���Hy'8
m��h�:��ɯ� �C~�p� ��çvx��?I��5�X1Ro�=�ސ�L��FVYҷ�SI�B&�ʿ+����ې��UC�:���Y�o���|��� ߰P����������r���߿�`>>�G�41����ه�A�o��ǿ��i���
H|�ր�y"�>!9���E$���ŉl�������]V����� �:v���X�NOl7�m���"R��R|+�H�Z_m��F���-��5�U�z�������8{\ފ/Iy|�]ڰ�*����@2Gb}��_�;zH�#A���B� [�A+	���==��t.(��Q�&.�;��yԳr����a�549PF��^)Z�G��,	n�Ly2Z�jx�0��F�he��U�g:��$�.7Q��T
���nֈ~��!y:���W�G١��$�$�.���QX�r'n�i?��4�^���wzW��C������s8?:d�2 ' �s�3���1g���!)O��3Qv@��a�9b|H��93?W�hw��fNmlE�h�"�UǞ��;�VL-��J��SGؤ/#o�g�ī+�6�=�	�Gr����@aNCRgU��VA	D"L�`{�� ��G�e3��`�o�a�����J#Sa�xN�V�ў(�$> ��Pݍ*�&[?r���V3PY�:��D#������+Ap1M.�N���|o�s���H�|I;��"�B���ŧ�{�C\��./�-�x�[��V��rqa@k�̀��s�*n���I~����M��)���ȏ��7��[�,��:�l��pOr�������>�Y�����h����,S���
�L2uq�L�^�x͛y�L�?�}|FlR��#��{�j����N�$�`�~K��fv{
)� �����4ځ5�:��%^���
9����O]š���q�l��4kHn^K�k��p���t�� 7g0"���J�ACCLb��ẳ&��I\�
W~`7��[��Q�C���
�t� �����/�mb�r��r��Fݡ^�"t=��(�������K�˫D�7
do�0��)[��r{U_򣘌-O�yM���19)~��wb���В@ӽ�����`O�L�B.�y��%f�cl8���K\��Ax����3|���#�W��k�r%�h
��LЍ2I�S-wA�3a��b�F��B���]�r;��f�w�V�@T0�JvrB�aZ��ӀFޖ*ks��E}V�M<����:�s�%�.+��RN���x��&��-	T�iT1�h��9ծ�S��T'~@-��q�d�8�J8>2�ekeYLk�����v�y���9�[#���͞z�'�U}��+%��>]l���r�Db�즥An%0_Ȥ/`��U�U��"���=S@�S4$��ͺ�(����۬[[�dO}�WS��B�d|��i�ꐋ�2�G5���B��`��n��Z2��m�@~*Q�o9�q45-��LA�XAr�+W)/����.ˁ�T���)J����)�9J�����/�-Tr�45{PӚW̉�fq �   Of�{��� ��(XM���6�ҮU'�0��3]Ơq�m���$��̡B�1g{p��d�5��c�c�7��C�ĝ}Ϧs!:&�7�������{��c���D�VtO*�!�V(�����4��yS�F�ⱺ�̊�Q��E'G׀��ے��3HXVs�`J���Wy�.(��r�7��S-�L��o�Vs�r���2`4��H������U\0��Po"�[n��-wmˌ�9_v���ǐѳ��{��9���C�k-���u�W�B�!q��J<�S�Ѯ��W];��V��e:�ټ�O��{���T�ă���F�6�r|O����������LZ�؇޸�m�.Jz��̷s����f�}�T���u	�I˰����!���J8B!��3��i(؄�K����O]�wU\N݊wuM7%��̐�̙I�ͩ�����呜Bn��>΅��[vn��HY�t)�^���D���4����cŜ��c���D%//.W���"��_�&x$�Fpt���TzV��F��˭�/t��*�K ���-5�M�MM<CM�%��<�u�+� Wc��Q.v;'��S�[s�u�u�[*�g���k���8���6�O�V����r�3A�U,>l)��A�W<�ئ��0$��J:ڟ�M\�J����Y��M%���M�Rx����T�d��8����YA��U��v��6{�k��bH[�l��M�SF�9j�(O�9n�����z��)8�Ή�_2�7�mԈ��G�\g� Y�
hW�'�Q�z[^��U��a*5'����s3��Kt���h9(�M
�t>��< 5{y��p�')�[©N>�B��48�w/� ɿ*��N�I@Ss�Z��O+7s��H�p�!$���N�|���Г�l湻�&>4)�2�<���w��8�&�E�&̋-�T��2��`=VU����m��P�$�2��3��p�M��ܤ-JB�)C�x��jc�>��j���mДS��ws��T�vU%�!1{NvR��`G�P�_�;*��}��E�,GIT�T}�]����뢸5E<K�S�-�L�i��b�9s�;%R�HM�g�,���G^�)i�����Q�G񺍯1jH�sWJ�Vn��Y��ڔ2�9 :0Q��J��js�CvJ����f�-���R�j�BRp:��i3�P&�z�C!��U���0�.]�m�LU�R�h�gh�͵�af12�I��>b�h�Ŕ��䂂�ز�e�J4C��4gh��,R�u����3a�A����%ff8�N���<0n�V�2nܒ�d��UM���bq��V���U�)�P7XC�=3_�&�P�ѻ[c��ܱ"GI�X���ՠ��!BwU�������"�8��M�;])�9�m(�P7XC�=ӊ�&�Pَ�+�m��@8��Aң�f�q�[jw��̼��b�K��t��F�+I���NOk�E�ˡSu��g,E@.J�m��۽��̩�o�+�����]t~>��O(;d&Y�iK󨭝���m-�;$CPy)���3�Ɨ�XO���&�o�<��� Y�{��`洀y�Zf�O�&9��SW���롋τ�rm�+�#I� ���r��zX~�����;YM��C'�������&ٌ�}SP!���Y��;����ܚER�- �w�(��z�*�S����y�<�!�C���_!���%�^πUU�?�L�B�H���2T3V��T��2h�f���z���+ۇA�Q%7��]ź.��o���8$�ń�*���&> 1t��R^m~y�F�ņU��W�!Ah~yX�V�l�C�,��Wߠ ]?�G$7Qw
G_o2��~w�[�����f�����
�.�=��4�|F���!S�H}x�[�H]e{��@�gʳ��H_$�Ĕ���w
8��
Q�m����_�[S��d�¯4��(�J�^iRo�L!�i���_IF��YR�B�y�����)a��a����R��)�!/bf����G����.(O��@��J��ANJ/+�5�9bf�O���OP�f�����C�-��	٤^�k��7y�,PW��@ف�qO�km`�����{??�r�]�U��T�9��U%�Nc�G.�f���_7�
2P�{�M�(��#u����O�=�z%��*�P"�\v�d
�;�`�(���jQ�9�B��Q���A�Zz��j-P�08Pj��9R�S���	f���9�2��-�[��=�Y����o$<\�+����̌»��yz�a^��ۈ�{����`1y%YL���eY��+M�h}:�:�j"wf&~�һ��\ɫ��*$Eb��K�i��`*�*)F\	��r�`j��
z53R�tFR`U.�U����a�[�wJ,��O�>ś#�KNޥ���ىڑe#֛,/}`���3&R ��OY:7��Sy�=93�/����Sw�stL%��R����<��.J�fȳ5���NWB{�A �um�%S��:W���&QY3(ê��"(���-�%�}%��T���3��b�j��!��j�L����\W�J���mGhdř_p����%�H�Zo -��k��4xa�lo�2��!oo+hsf�c3�V{�<`��N^����-�$�;�g#���4���dB}P��3BN�	�A&{J�]q$Ň���	� H�q��:7n��KkQ��2Fh�y�e*&���S4�!�}Tl�L�����0㟡���(?��^�:�W^��|��|��w�����9ߚ�3+�Wd	���N��9�u���o��#׻�{��'&��Q�˙d�dW�#ա��_�F���YÞ�lrT���:2��E9����%rY��J_fvuD;M�MKh�g��l�U���=t�K�"�v�r���5S�������۲��Y���/�|�3!f9z�\�N��2����t�hs�7�i��M{L����m4 ��i��2��P��EI�()jH��]��Ƈ�D73O���a���C���B����h��Wڸ�Z��5�Gg1��b� 9_�r|-F����{��y�*��i���+3��*�d�)�}�6�Ꮶ�����١Y]�},��YC2R�j$><�W�.09���MAC;���iz�:�;�.�긃���3�#.�1���f�rruXT�9W7R�6n��4{F��j75�R�?ռ��Yd@�������~���~�P>~�_�Q�����/Z�[�Gb��W��e�/[�sK�;?~��ł����.��,�d%����* �.��%���cv��}���,�[�������?*��G��+~�U��wR���3t��(��3q����U-IW��v��4������ț P�"�)��ع�h��Ȱ9���\��<�&�����������x��f/��ǅ�E�?=\�Fp�"�f������:��<�2�����މU��g>,1��Zx������UK��q1�<�i}�\�z*=PW���]G������W���� 
��9�4���kҁod+*����U%��>���?�I�      �   {   x���Q
�0����0�\��B6�-������ćN���OKe�p�ʙ	��^���#����r��.
>�,>r6������g�r�dO�W�b�˰ЃP<�C�04�	��y6��9���      �     x�͖K��0��ɏ�uu��n�����@�y�$C�~�ǔ��#��򀏎�#]˻]؇����p��^�eS��ry=����#a'�'j��z>��ǟ�a����!�.���< \|I� 
Lʈ%%�(b�d�=�?�[���_������������r��u��ṭe{<���b��2yS�('1�K�6M�s�X�i�J�96��4ܖ:>\l��#!ݙ��3V�;Edf�5%_X�Z*J�戬l	5�h�k��g�����GW�͕=?�]� �8Q�aw�1*-�P� p,��s	�V�E잡��<�žͷ��`�3<Q}l�"ِ-��|�Z��j�\
q��3��^�b��z��O�l˾ИI���c�����i�;�Y�C[l��"U3Q}�Z$���m2l���ǯ�q�X�����`/m����ke���hK�\�O��P�2'��g���4�ž���4�8�4Q}l��)��q؈� EC,Td�����ts����_>����h��i      �      x���[�d�u����|����q��B��GF�V7����\3�+2"Y�j������]�>� �U(�`�2m3������O�s�y�a�a�^�a�7]�T�~����P��q�V�f����������};~|����}W�6�z���X7�v�i6�f?Իe�����O��ש�r�X��_�_��}���������C�����ڼ��?��z�܎�e��6u��wM߭6�m��m=�V�/���_ �/����v��a�YO�w�~�m�	���m[��_����@"�_ !�/�w��O�M��Y��fٴ����}�Y������/���H���<?�=|<<1��-���]7N?y�-ո�~�[��f�w���Z���wâ�-�E[U㰯V�z��æ��0��_5�v���iQ���^�W���/�fZ�����V����ž٬��j��6�Ӷ}�U�}��֋i��z�ֻz�fj^��0��Y���������o��v���i1���YϢ���z�,v������l��a����b9�}����E��F��~1��ݶZo6�j\n�n�gآ��4���zU��e�VC�՛z�TúIf�.��0��g��D�����^.�q�V�f1Ÿ�O;�������/���HH�v�^�������u5��iNM#�H~�.������$���o�_�N3m���zl��~��v��6�������N ��N@��nج�%5�֮���ִ_�c�_-�~U���Z�N;�0N;�~A������]�����r������k��rL~�.������ħ�0�6��jXlVU����Ů]n����t�.݋t��S�S�����_O���/��ݵ�ᶮ�C�ڮ6ͺM~�.��������ٍ��^��AX�i�w�iX������Y<[
a��Ǡ�����^���~*܏��v��b�����@��@!�1P��D[L?��/��z_M�������n܎�bHO4Y<;��8�d%��pxh>~������O�����������߭��p������{�0��ӡ����n�?-�v��MG|�^O˭���<~y}��z��?�����5������o����/�����0�=��/����9�������Zr��?6���7��� j�|n��+X����|Xna����i���um�_>^��������}��Z�i�������*Ц��X���p���4BC��t�v�?^�OC��~�����4DT4��Z����j��W���ٮ�=|�7�j�U_wb���k[��׉Ŋ�&�J#��0���m�&�DK�dL,	*�X}����ծھj����.�-��6���M�u'����c��o����y%���Рhb�FYK���u|�+P�$��jzq�M_M{Y���j������^/�v?�?S��������Ǉ�wO?��r{h����;����z;-�j�M��76���WU���3���i^��3�ة��OS}����������K{x뫻��������<5������~������ÿ���?���M���������������;L������C�K�?�����������4���>�=ܽ|������S��4a�<7?M;����a�����}�tx��<W���.��M�����4K�~�t���'���\������4T�^ �����s���釷��rx�si���;���&z�p<PΟz�	?��c״osy�l?���z�)ƾ���a�6�z�v����^,����tn�����t���uڻ���n����~xx�s�w�ep<(_�7\��ܱgε�7?��f���ux8��OC�O���~:���՝�Lg�����S�7�S7<O����өz���������t�N�5��b�1O���|>��O�{B"��������y�2�VM������|�,�����^��>~��������߮W�[��o��4އ�y����7��/�L�|y���经w�����S�㌛J�5���a���N'�����|�O�]�r^��ۭ
������j�Su��~>� ���/�S��	ˆ�|ݽ���� �팽���������r菣�����%���Z��4M�����������ߟw����n8>�p�fC�}����i�=��T����c�� ����0<tӑ�|�>�I߄,Dt�S���up��Na�����|�Ի����m�~x����Ê,��t.J���������%��~��>>=�S�:w��|~!�¥�����'��~�N�ן��Ѵ5���6����t�j�=j�� �������a%��Gz���'Z�yx^��ˏE��IQ�yx<�k^����b��T/~���f�2��^��<N��y�2���Ԅ͝�1�j��Ql�}��qxN6���n�)�Ǘ�{��qK�C9�y����0�v�s��o7O�{�?=M�<�o��C2�X^�<M�ės��ȶ�t�:��L�������ˇ���װ������//��?����?��w�p��k���a�w��i������������xX|�W�]^�mIn��o��Q���7���{��ӽ���N;=��5�7L>���S8'���ɗ*k�Vz�D�����*ZN�z�g}������TZ���>^K�_K�ǩsxy���{��a���Yc�����.�u5,�u?l�m_7���z�u�в������Y��-�Z�"��n�e��(���2f���c	+��C�V}��lǣYj�6ͪ�7���Z�ú�}�	)k�MHV�2!Y�pBJ��ȕ�h>�6Y�Q�����2���Q�c�X�m��nW��˺��W]�������_w>��o���GV:��al���f�n�5#%ʚ��*cFJ�=#����n�[c[���PU��Y���f܎U�\m��¬7��z�B��n]��m���v��ð�wf��8,��ts�/�uU7���a1N�����|��֬��zۭ����W�����v\MM�w}o�S���j캡�.���ZwM=��a��u3�f���hS�S���o�����SK���XUu�Y}8F�ջu��wM�_��v�'vm�Xm�z_x��0���ߏ����nW���ԥ�z\��|�ڃ���F�tt)���%*>�d���H���]�u)�s)X�q����E��t�U�Z���Pخ�m=}o��~�	)k�#T�z���q��q�P�q$[eG
eLH]�u)�s)X�9M�����m6U��N�z�v�i����b��wHQ�-@��ȱ�a�D8[�@%[�j��E
��E���-R��-R��f�Y�뺯��M]M���^]���~���_wF��o3���HV<��a<!%&���M�|�(c>Ꚍ�(A�|�����k�Ӝ��n9Lӱ횪Y��z���u����Q�~����u>���|�c>JL4u���XV�bl�Ͱ�-ݶZo�#�t?����*�+	j������j9=�6���v]ծ���"����eMVP�š����\,7��j��.�����o���o��:{J�W��2���_���s��{|��B�?=|^?=����o��J��ӟ��������o���8����/�����w���K�з?�/��ǿ��w��Ǧ?�	�鯦��|n�Wo~�8�c�^������������[L��^��{:�*N|8:�¿�v��Ƨ���=}9<�Ǡ�>��Z�S�r8E��M��H�ОZvx�K ��X}��1���r��T���1�����/s��)f��.���u�.>�
}96�S(��OF��/�L�����_ ������'p6�?�mf�q�ş��S�D�~��~ q��
�K��tx|�����t
y��N?+o���4�ߎ� ����f�����w�4)�������%��	�ـ��O�iW;n�4�y�����[HeQ]�1�������,'ľ���X~Oӏ��|8���r��:�)z�� o����g�G�iO�0]��������G�7�����x/�{dqMg�ۏ"�A�����������Ⓘ@�>�w]��Ƿ��#f�Y:�RO�'����(ܸ?���^�����������ԝ4^�V㱢��� ���P;^s�L    \�7/�C�;��e7$T�T���uږ��>߽~ �ꭎf^����gRz�Es��x��i��s��`���#{�x|�?�5�}��8]Fp�����7��)��KI��O/�C��0�*��1N�Yp����n��/-�7�=��ۑLo�%e�O���ￂx�O��x�quw/����~��D�*�S+�Q��zE�������(h��9V�)����������|��z���7v���W�����t8q�hD��%�z�*����g�eD���<��[�)���M�k:T�i��5���_ތZ���~9�8_����) ��ô��Ԙ^���q
�<������џ����a��tX�i&��7`����4y>ܽ��SF�~|8Jo������K�������H8N�sD"��'��D�����o;��o�臕�����t��xֆ����2��sO��Cw�=���<Ѱ�a<Y��3�ͪyB.�}����~�m����&\ݭ������7ӱq���:��׋-B���6Y6�w�����jYH��M��iY��!Z"CtA�����`��USUE�l����[��4'���9X�3r0�A��`�3��e��.'��Ao��`-����1&KDB֭2������M�"�Br�^�19X�����>%SӽE�،�,�9cr0��	9X�d���b�����,�>9XoO9� ���9��;iL��Cr0�,E�`�����踻��q�9�X�`=*	9��39�|����`O5���7����P��^=K���o��Ѵ1���Ԉ��%�A�jN9�"sr0h�O����Z�"�������������-r�>�9X/[D��A&W�+9X�A�5d�`=9X�Ō���r���ᱽ>����d	8<>OM7��?8�y�_{�+|�6��`��G�h�a����r8����]U�l�oV�7o����3��#�5����h�?yΞ����S �4��Ab}�Ͱ(���1Q֞��$°�IL��p�US�,�ߚ�w��(��À��N���8����<k�u�|��6o�7?6^
�?�z���p�8�_r�t�<KNaA�/�傘�.�;9D�;zv�aA����giԇ��KDQY��0$6��>���1�q�N�>5�o"�g�������p����X}�:������xM�Nūk+��<W���-w�ax���zl�1���"}{R?����h̻<ulP�|�6`�
������^��9���/�_?�B����(��t2~8F��x8�� �p��@��97	:COv�C{y�`�����+����?@�O7��E��~�����*N�gx ��Q_��U�5O��m	����c�@�e�"����|�	�x���u��h5��EШ�S���땊U�!�L�Qt�#v�B�qfӅ'+c��Ka#�5,pڛ�^:F�1�y�D����{��
������4��S��}�!o]Y�Ih��cTGh�e�O��/���b��BI��[t���ꚛ�4����;��Tr/Y&��w^ɽ�+��ПX�]Q���[�Ȼ%J�z+����1)��6%J�e��(CGɝD�J���ɕ��z�����܁��c���K�!B���&��{mJ4ymʏx�M	�_�����č�_���6u#��&����dC�6%�~mJ�~m��MGۻ�!`~/C��^�`��L�f�e}�9cֽ��L�B�$ʈՔ���N�4�����J�f���w�x��N!��r
S������4��j�W�ط��~\��fl�v���ʕ�� ���Q�p,$�T�8ٕl���%ʘ%�&��@N..+T��cU�כvQ��nwc?�6��Y׋>�� E�R<��P[�C�̙$Q5=㗃�(�#������o��TU������E��w����@��M��$�Q(s$j~$������z���;���.Ҷ�j����~�P�� ��a*�(�EYP��!��2�����Ūiڦ��M���a�h��n��E0��uX�p4��S(c$f~$�h��Ʊ�j5�C���V�~�r���`X�����h�5e�����f��-vݸ�]]M�t�\��q��7�z\�"�)����5M"�+�Bٗ;��	/˽�,��ZM��Ŧ�m�f�����_�}ދX�� ��� h���V��A���AЕz�U��VI�kҔHˤ)A�I�U�4%��4�G<����IS�L��q�I�R��n�m���L�l�#�&Z��IS´I��o:�9�M����g�O�p��h2�'B�O�����;��O�&�S����;R�'���S���2�7���'���,@��O�@c����!�S�}������I��Ss�'���O4���������?u5�E�SoO�� �������D���_�?u����8	�S�p,�':�.�O\����?���QI��`՟�����h��{����ˌ�����o�Y2��/����������F��,9������O������>�S(��ϘN=|��޳5�S�����'��e���`?2���J��a2������?�\D�O=3��>ff��z\�'���)!��O�A���=0���V���)����2���	��k�/�On͡�?)�����?�;�r�dg���K|��?B�r�n��K���?�gO/r������K��޷��?/��g�X��c�斸����'�_�,pdr�q����T�C2����	̑���D�2����r�a���۩!�OA�V>���u�r�f��S`"�^�%r����3��U������M�92�Yޒ�G�!��ׯő���T6���>���;2�~��b�M�l>�ܿ�!�ܿnJ.��0��?xw����Tw���%�߱\���)��&�ܿ�3�`R�����є�g��P����}I����3��6A[�_og�T0��g��+��� ���#���v�H�.(S�E[G2�9�W�:/`�Y:/��e�_[��N�9�v�:/g�I��K��y��YO�]=gu^�q�鼐���o��P�X|b�����,�s���'~'�,�S��/$:/�,h뼰�Dً��y)Y&��w^����;_��(_�E�����쾡΋ފb�tLD:/�뼔�J����y�:/���u^�z�t^��t^�_�a��z�\��q\�պZ��b�ٌۮ]�պ�0��Ê�t���0e�a$j�#�yd����x��"�%�G=�E�#��pyd<�kd<�32^��x=���x�H"�u���x��"�e����T�h�g`��>������x��"�%0��g�42M�$2^�dEƃ�G��j��x��#����E�d!BF��%�Fƣ�}�/�#�u�02^�N#�%���G��%2�E��aF��QI"���?Gƣ�O�Qd<�S��xp��"��Pؑ�z��G�K����OO�(2��`3"�%܍���<24ُ���"��g��v=��x�g��x��Vd�>�Pd�^�(2�GFd<��_#��0��,2^�E��b�����x=nd<�42^BJ#��ed��x}�I#�%����_Fd<=���x�#�ɭ9��'� (R<���[bOvv/2�Č�G�#���fd�D�GƳ~�"��-Nd�D���}E����x��#���7��G�kd��ay������C���Շo#G�ͿD
��}(V���'
Ї����.��>�n�>n\��a�>�?e�P���}���>0=*}(>��h;t�#�t���a��1��pHF�AМC`C��et���t���0�Ij�a(�B�a�c:�#��0�A����L\%tb��0̛y�à�X-��0h��0��E�A�!������^���0ڑ9C�A�##��V�nt��t=CR:�nJN�A��mg:�������ʥÔ M:���t�ft�G��0ԯ`�a�u;�À9>C�ѷ`�l&F;l:��.�tT0��    0�ץð6 :�~0�<�0`��0pA�tf���0ЎQ�L�0`�Yt�.lh��stv�t���0EGRB�)�zt}���0��>G���iF�!��o�� A,:�t��0��a�1ޢü]fܒt���}6�=$�^,.�d��N�y:Lܧ��;_L��G�O��#c�a��'���(�àc"��@TL�)�>/:y�t}��t��=:���i������n�/��v]���v�n��nܬ�1̒��޲$��Q�$�0�$)�I��(�'I�s:��:��gt�p�0�G3:Bt���0�;�t�&F�:��])F":�n�A�a�o�#l�a
P!F/И�g`H��}��a$b�C�Fs:��t4�:��ɢÀ��at5F"}:�ޞ<:A"$F/1��z���4����!F�N�0`�a�qw����7:��&F�JB���L�A%��G#:�SM:�hft=6�Eϒy:��t4m:=5":L��f�a$ܥ�PdN�M��0z@F~Ƥ�����a����0��-:�>�F/[D���A�!W�+F�A��5dt=F�Ō���:���!��HH)FP�at��a��&��Hįt�_���F�|:�5�tR>�"�c:��S:��=:L�1�� �O��p�#��t����/thap�0m�a��6����:C�t����0r����G��O��w��F�Ϳ��LV�U��a�Dt��:tp)�0l�%tܸ��a)ޟ2:��F�`C�a��=�� ӣ����MGۡ��9��P�˙��)�C2:��ts�0�F0.���x��`�E��OR�CA:+�a`)��:&t`�*���g@�a��+��0�j�F�A�v@���-:�F�]F��
�0�lL�ю�:�����u�À�'�����atSr:�Xt`l;�a�Tw�0���V.�i�a��4����0�� ?ZF��~�ì�!��:���t`;0�0�`�a�vq�à�9���.���a���I��`D��ʤ�0�DD��v���dJ��΢��~p�0`C3�0�4��ð�8��0�M�):�:L֣���G�a��9:�>N3:y`�t}���b�a0�� XN�A��Í���2㖤��/$t���0�!Q�bq�0%ˤt���a��>F��b:�>�|:��Ü=!FoE1:�b:L��y��aȳŠ���'������a���0ИO�ì���Z7�f?V�ah��n�k�m�oV�
�à���0�x�F"��0
eg�Q(�FV��)����bx
i��)�'��*s���ᩏ�bxrZ�bx��)�G���QX&�'���
�74��Y����1<<��h)���K	��yJ(��RB�q�SB������P�;n)�to�)��J	%��,%��aJ(�*+%}C8}�)�8*J	%h�J��(%���,%��̤���<%�)�$K	E&|�J�d��ҋ1I	%�qSB��M	%�'7%@"tJ(����P�w��K��P�x�J�qҔP�c��"��5%-���?�N	%G%M	�W�%%)�?���{��J�.�Pr(��Nr���P�����"��J	O�8%T��f��Rp?%D)�t�gRB�e)��g�Nr6̤��{6H	%��L	%O(�J.[�J�GVJ(p������d����,%���,%���yJ(y�̥��#ৄ�Ð��R��P�:%�쁹�P̊��R�_9p�=��P4�
ܚ��P�|(�')���1J	vv7%T���H	E�3)�(�N	��"%�g7%B_SB1��J���P�}����)�"I	E޿IJ(䖸���7,7%T��M�g���8��0�g�!P#;�y�a(4͟Bqyv^�%;E��a����A��0�|��Ցe�A0+;��a�k�(;0���a�c��ϳ���9;qd��aTy3;�av�Z�	<�C�&�a�Oc.;�y���bT�Fo>av9C��0�)Fv�1���w�%;��^vx��w,?;L����&Qv���a�I=�M�vvd芲��9>�F^g���g��F���0r��d�!��0���à6��0���À]0����FZG��0r(��ʲ��Ugf���/+;��a�i:��Fv�s�ÔIiv���F^g��0��9�F�yv�����g�^�@��0hd�!0#;��a�]���>tY���C��f�afA';zH��X��0ˤt���0%��0�Ηd��G�Lv92Nvd����ȭ(�C��8;�E'�a�@��K/;x�X�a��cd�����C?0���E!f��M�/��j_���W}7��Ǳ�l�t��
��aX��F�r:��̓a$<���/�Y\�D8q�?��x�2��.����q���a��K��gW/I\�n��@�P\�l�_�
���������x��i\�D���Sl/�y\<��q�h�'q�&+.,�8.^W���K���'/.� 2.^/17.��;i���q�t/f\<:�.q��-.^�3.^�JV�9.�|������j�Ńkf��k׳d>.^⍸x4m��xzjDq�%�/�n\<E�q��~\�P/?cƶ������=[���>����	�����Eq�`?2��ɕ���Ɉ��5dq�z.��x=��x}�����p���0�q�R�?(��u����{M/����2���	��k�On�a\<)�?��q\��Ӹx��{q�%f�<.���x7��%z>.����З�xhap��%ڈ���(.�����3D�޿q\<�\���ˋ�/C�����q�q��^�4.�C��x���	̉���$r㲸���q�a���۩OA��xV>���u�q�f��S`^�%q����3��5.�����-.^�'�xYފ�G�!��ׯő����xT6���>���x�;�w��b�-.l>A\��!i\�nJ�0V\<xw����Tw���%�ܸ߱���&a\����x`R��⩉ь�g��0.��x}I����3��6A;.^o�xT0��g���� ���#��v�(..(3.^[G��x	���c0���Ί���/#.����xt���ų�8��g8;.��HJ�⋰^\���zq���9���,.�<0ܸx}���Ċ�G�<.��x���]Ί�':���G����_H��YЎ�g���_�LJ��|\|܏��w�8.^Q~\�;.��}øx��q�蘈��-:��/�>/��x�l1���������������k˔�� ^ج���e(`�]����y�V���@/~�� ]����f(`.�$Cn\�� ����v�\a��%�P�W���@�t�>���E�ٵ�j��q[5��.�M]w�a;��n5�-z��B��^��E�*s�B�E�>�.zL�*n.zڸd�SX��e#�EO+=�x�+���,z<��hg̲���~�7}�[T��n���q�^��~�S&I��G�(#�@b�8}�����1����a�6��h�[w����}��cE��>V<�y���P�N���q�@�yh�������B����B	�B%����_Fh�h+�P���B�MBI���L�ǡ����-�-,����B��C1�-����B��^h!C_B�n9Z(��I/1Ih!/	-d�8�Po�Yh!�\C�5�-,Cޮ��z�l��Y8�6բZ�݄���~1=�~��R�%�P��C9$-D�<�����BM��0.-,��Z�Vh�[��t	-d���BXGZ�`Fh!&��VZ(?���qh!*���9�ʂIh�,o������Ah�,���qh��̅�ߑ	�V���u���M^���A4�!v�T^GZ�f��n���������:
������uʒ�!8C^v�M^G��-��p����]���0��:�U��}K�:��o��pT$�#h"�#g`$�#�>�ב�y���uА�A�L^�L�T^G�d���Ř    ���j\y�jp�u����� d!B���%����}�/M�ud�H^G��Ry��2�u�qw�ס�y�3ly9*���^�yR�	~4���{�-�������
GG�!��=����6��<5by���͒�Qp_^"y��y9�L^G}Ɩȑ�aF^G��@^G��)�#O(&�#�-�����%���7y9L���(��u�\d�:r.��:򘙓ב#����a��u�X^G~P������aQ:���B���e���	��HЌ��5G�:�|Ȣ�yyH8:
��|@�U�C�C3��u>��� 0O�BS%��u>x���0u>�1i�|@�U��Ot>X���Y:��|�kw��x��:��z�� �s�}�:�|���P�C�7u>�ou>�u䶸P烔Mt>�quN���\����|��'���3$���M1t>���������·|�:�%:H[�C��"���:ڶ��|@[���^ܑ·��s:�e3�󡰞·4N8:r���|�����}e����!mO?S���:lA�:��| ȡ�ȓ�|�Ug�|@�������9Mgu>�ql�| ���Qr$�:%XW�C^g]�r������i���·�q�B	b�|���A`���:zi��|�]F+�:����wz:�!Q�b�u>
�I��:%��y�Kt>�5��!G����.�T�>\�o�`rU�%vV因gT�)�V��������U�f����f���-�ņ�7��E*߸�U�!�o�bs�o��|��#�o����MW���v�]U�j��u�hvM���U���!K���F��ah�FFh�D��3����.4�ջ�PW��	r�.Xe�ޅ����*u�.4�2һ`�D�7.ֻ��T���3�\�ͿȆ>һ@�ޅ�i�>��h�컀2w�wY��ˊ���FX��&�������~sD�^�7�:"tSrG�X�ݼ�#�G�Ħ����bGD	�tD�9"4G2sD�&�@��zƦ�0�g�b�;"$�qDH���$³#��u��!?�3uD�]0rD�e:"$6wD0H����8"����x�`C3�4�sD��8wD0��(:�GD�sDh���@��YG�>N3G�p���Yru}��0qJŪ�����
�J�Y<Ua$a�
KW��*L���0�����;#^��&�x��K�+�r���E�"h�J`N�+�&1��E��x�x�+�U���W
�D���q�+�#�xe0#���W	+�xզ�(�U�#^Q�,�U��9�UL"^ey+��� �U�"^e� ���#^%d.���,v���u34��'04���tSrC�X�&ݼ��	Mu��$��������T�4M�S��n��tsC�t}C�����	��C�D��$�14I�ch����Є
�&���&�`h�����.���2M��$04�qJM`�Y�&��M`C3M�4�34��8741�mh*:�CS�34��ghBW�YC�>N3Cy`��&}��MbE�"`�`y�+���`i�D���YE��/$����D��%~�v������t��u~:��,�
u�}KLѥ&��`�"����q��v���zd�`_�����ߑ+&2��6%��2Pi�c~'���];xr�;^��`��.?�K��U0/�=D�,���,�cʤ`ʐ�E�\
�v�U
�)��y.�7�T
���ߤ`u�)X���`�I`I��B)X�@c)X=C)X�N�`u��/K��,;")Xxj$R�h�'R� �ѐ��1����xR��K���ɓ�%�B����:�,��w��X
V�`�&���7zK
w)X\�&�b���D
���,*�?I��`,K
��a)W=K�`u��\
MC
���l��fH���'K��,�J6�`��")X����\�l�`����`u�[R���BR�,|UJ���Ȑ�%W���&C
D�R�z.")X=3)Xz�K��p�`�0�R�R*�?(�`u�H��{M*+�J��2�`�	I�j�/Kn͡,)_��*��ev�P�������i0 ������N�i0�~�4���� -��D��j0����5��7�`@����ay�L���zQ���a�׻}�i֋�fw;?�}��~3�~��6�Po��f���M�Yn�M�N��vY>�n�,�A��vs��14��Ƹ,����st;FX��lE�S�%������ait;����D�KXYt��\�.�����xݮ{��.&����ݎ~C�.����lݎ����2ݎ~G��ZY��E���'�n�3$�n�Mɣ�Ɗn�ͻD����D�Kl�^RY�^�4�����v�f����yt;�t��v=c��v0�g��%z&�]b��v�s���vq�nG��v����� �]~�g�v�(�.(3�]b��v	���,y����f7l�U��U�7͸���8��fz�-]&V���Ċ��La�2I���$1s�L �����X��u5�dm�����zii�I����*�4�$�h�ɏxzz*Ez�S�$��k�aX���ik��
o66���Z𹆞�i=>��h;�.��,]q�t��9�tqHf�B���E`��C[�e���ϖ.��,]lY�(�b�b�cK�#�t1�a����%ae�.�)E�.���,]�xf��=s�t�};�t�����ҥ�.7K�,X�P���%!s�.�;2�ke1�f��O`��3$�t��.��,]�yK�ꎥ��UKWIe���iZ���4�t��0�t�&�.����.=cSK��3�.}�-]�X�$αt���l�BsK�}]Kk�t�����v����i�bF������T��:K�؝<��:�4��q`�q���p��Cё��8a=}��tػ}N�A���y`�:�ƙ����q@�\��r�u�Ҟ�qx'�̸%��1v�t��C�����,���;/fP����/3�G�/f�G�3Я�T�@oE��:&"1֦D̠T��t�ȳ�3ЇO.f�׻'f�?0'f ?�� 'Ō����S1�KM1����3@�\̀v�U� �)f��y.f�7�T̀�.ob�U��}Cb�$��
P���^����������&b�i�Pl&f���H� ���������b`1�b�O�@"}1�=ybY��b������}�/��t�P�@�a1}����qw3��ob�*f��QI���?���O𣑘1Yb�6U�q��,�3О�\� MC̀���A��f���'f@������bz@���~�X�z6�bz��b��-1}B!1fZ�b`?2�ȕ�*f���3 ��T�@�E$f��b&f �"���W� C*f !�b��R�@������פb��/C̀������b�����%�7����bdg��4vN� �}17����3`��@��Y� Z1�6���63��/b���o,f� W1}�����D�/��u�Z�͸��ͦ����fX�U?�����-�9*%6�3��BY��f�@#����(�e����X&��,�%�Lp��2쎛���[`Y�,�e9�2�e�H�e�,�e��|����2GE�r�&�rF˲�3�e��X��\`Y�e��ɄO�eM���^������XV��e�=�� Y���r��ˤw��K�eY<XV�3�e���qwX���e�3l�e9*���^��eR�	~4X�{�-�������
G Y�!����2�6��2<5b�傃�XVp_`"�e���e9�L`Y}�I��aF`Y��@`Y��)�,O(&�,�-X���%���7�e9L����!X�s�	,˹�,�cfN`Y��/���!XV�b�e�A-�,{`N`Y�k2�e���'���I�<X���epk��A�P`O�喘	,���X.0#�=#�L���B�e�Ϯ�2B_����XVhK`Y�oc�e\�*����2y�&�rX�7,W`Y>9<u(����P�m�C����    C!����*�ԡ�D�Pzuԡ��4T�b�-Q��ա0,U����L
Wx�AbC�C��{�L�J��o<�%�H �yqD��WG$+:"5�rDj����]g����@�>S�.��t�o*��!�@��]�tah"a�q�@WA�g�.����U�袠�@+t�:R�.3�(0�V��.b���C�*Ѕ�g]�p�&Ѕ��@�K����o���q��@�����/yF���Lj���u��O ХgH*Х��t!�%��g�.4��.j��o[W��i
t��A(Хw�L��23�.��1���!�s|F�Kߟ}�.`�1��/�����Y�����
t�6 �.�f�y
t�]0���bv�H���
^��@Xu�@��W�lh�@:M���q�t1�-�Ut$%]EXO�K_g=�.f:����i&�E�@��qf
Gb	t!`.Ѕ`�@��]�b	t�]f_�]��@t��]�!Q�bq�J�I����*��]��t�#���#ct1[(Х��X��@��]e���#�E�-�@�>|r�.��=�.��9������V��o֛aYU�j����b��Vݾ�����M�1%-ط�m��VCկ����c�]��]5,7�PmG+zuD��#B#,G�D���wD�ڎ��qqD�NO�9"4wD�����T�q�#��Ƴ##,G�[�
�8"X���Hf8"(0qDHX�#Bo.�#B��x��=svDȂ�#B���7�Y>pDȲ�#��2�@�#s)�V�n����=CRG�nJ�@���wqD���8"$6uD�T;"J��#B_\"G��3G�nb� ����36uD�9>㈐�G��:��sz�8;"P���`_��� �C?SG�#G\P�#BbsG��=N�#�:����#lh�#��s�v���EGR�(�z�}����9���i� ��o��%A,G���;"�ҞqD�9"�Ѭ��#��;G{H��X\GD�2)���"���w����(��G�vD�WR��[Q�@�D�`mJe���� ������׻���sDh˔GB�6����	�mv		��9	�U摐��$$t5�HH������f��p�b��$$�H���+,p��$$�@�IH�IH|~��Υ�������T�lo��L��)>�˥�hw\��@o�R|�pϥ��ޑJ�1��M�O�ʐ�c�oH�O� �_*���4���30����D�O_|)>�ͤ�ؽ/��W�D�M�D��_)>�c)>]�'��"O�OoO�A"�0zR|�w��Kc)>]<���w�D�O�p,)>t�]��p�xYR|zT)>���R|���h$�G�Ö5Ha)==K���K/��C�Ɛ⣧F$�Wr�R|�J�I�Qd.�Gݤ��P$ŧ������޳���sK�O�PH���Ӥ؏)>r��J��a2����!���sI�鹘I��cfF�O��+��!�ⓐR)>�A)ŧ{`F�Zq)>��U��!�GO�H�O�|)>rk��H����L���C)>��{R|;'Ňо��R|�gkJ�~������,�-��DR|�}I���)>������7��cn����ayR|���I1)�&��L"-/�9^0V���h���`Z),���7.��aX�Ӎ��`��}�Czn�L´��o<�E9�vC�m�nYo�����a���v��v�~a��V�zh���ۯ��v�l�qӎu[-�q�_H����>5��|j
g������S��q��ް}j
g��&��)D�S���|j�-��T�m�GE>5�@�����OM�}�SS�9���>54|j���ȄO}j�&ӧ�c�S�ո>5��������d!B����}j�w��K��,��T�̧� �O�wW�-���ϰ}jrTR��^��)�?����j����ɡp|br����[>52m,�<5b�Z��f�����A��S�M���e>5��/&gÌOM����&���������e>5�Y>5p�����0Y>5YC�S�s����\�}j����}jz2�������OM���OM�k2��B��S�����	��$hƧn͑O�}j�x�S�[b�S;��S��Y�A���(�����T"#&͞e2b�<�Ɉ��71T<��OKF�\�S��)cɈ�*]
�\�>�K?B<
Z�)��؆,
�̥p��1�p�ˣp��_D�*\�o�#ڸ��Ea��]Tr
�0�p���)\d�.m�.<���L�/���V� Y�<�	5�/��R�_��g�_ ߪ�~Q���/�G\��6�S��N�L�L_�B�s� ��/0W�@�\��r���g�/މ.�-�����Qp�/$8W�@���%ˤt�Ϋ_�}�/�_��_�B���~!q���ފb�tLD��M��E(V�(���/�o3�/�ᓫ_���_�̩_�ώ"EWL7���Q�̧�E�*�E*��<5��Fѧ��5�!��S�<J�Oы�}*�8S�.��(^�u���֏L�Cr=o5������T��r=o^�Eϛ"L=o鏱��!���'zެ�L��,=oL����H���C=o���I�\�[���z�Ė�y��7�����'�<�+��&e=o���&�#W�F�,Fz�z�	������eS=o�1�������M�����F����y m=om*����n��y� �\���z�(�#���s|N�[^�f�����Q0����..zޤ���`_Y����y����T�[�7[P��7r�z�̷X�������3���_�������MN�Y=otz���y�I��w	����YW���f���q��y����-o�� 2��z�h�y���M`���^�sz��C�9���7�B���̂��7zH��X|=�eR:}��w	|F�[��=oyD��yˑq����7��[Q��M��Xϛ٢=�"P������K�[>��7]ﮞ7����7���E�n����fh��Y6�P���m��f�fbQ�)i��[m�IJ�U���al�e��ݢ���ڴUȊ^#Y�0"P#��@�2"%f>"PW�EJ�(�nD�DZ��D�ʼ�@�&��#^D��QD�,nE�����F�F���c�}�o(a:"��o:ڹ � 3�	PH�#@��!�@(C��r
�W
�� ��z�H(�(t�
��(�	`	P�B
�@c
=C
��� ����	PH`.@� � ��� ���� �1���x�(�(���	Pd!B
P�%�
P��}�/�(t�P�B�q
}ñ(�qw���o�g�zT
������h$@�TS��-3
=����%�ॗ	P�icP�S#�(9�
	w((2� M�(�"
�SDB�_�B��Z�B��%@�O($@��-� ��!@A��W
=L� 08�z."
=3
}��P�p(�0�R*@�?((t�P@+N @!�
P�2(�		Ph�/@An͡ )D]�� �;�dg�(J|� B�n
PH�<���G�a�Z:�Dt�h5���V�1��cZsK\h5���d���]��fݮ���k��b�Ʈ���b��m��m��dE��HV<tDj�刔(�)1�H	�}H�}�'�9ԩO0	M��:�|e�$.�I���$@o�>	ͣ�}����$�ZA��Э2|��$4���I�B��^��OB���'�!������$(6�I0�u䓀���'�&|��5Y>	�c�����I�l�OBoO�O� Z��R&0E\�� v)��rH��EМ�K`�C�+�e|ނ�|^����ڼe�y)���e�c>/�#��2��������%|^�I	��,2���E�3>/����yQ$T���->/��W��G�C���l���A3|^�;2f.ke1����O���3$����|^�����p����y��i\>o	����K��ջa��>���K}�&��y    �B>/��3|^m�����i�y�S��������Es>/�}]>/k��j+�ϓ�v��������� �� ��V��祑3����|^t���y�q��y���I	����y�u����,�W���<0\>��qf�H�����y,��"X���=���Nt]D�y�>/�+�|^��({��|ޒeR:}���Ep�ϫ�|1�WQ>�W����e��ϫ���ϋ������1��T��t����b�y���y�z����s|^m�����S9%ԥrJ�E� ���*�M���#�S;�#*�,nQ9q�b*'��TN�H�ʉ+��X��GTN��S9%LS9����-�0ڷ�a�[�.�����d-N��a�T�E�Aq2.|#� �m��G%!� w��J>��Fd��"�Ф#E�̢g�<F�2�6��+Dd���
����=2E�d�d���a���Ehѳ�'��=[�at�[d��0z�"2؏2�%��a�0d]CF��s�a�\��0���!��p�0`R2����a�%F��F�kR2�D�J��e�a�	�a4�'Ð[sH�!僐R<&ð�M!���Fc��0�a0�$����iX?{d�V�L����F�2�bi����Y�7�v��W��^[m�M���r����EEoigQ�(��DX�����*�H;+�R�<OD\���Nϲ�`H��@�l7 �e���4���nx��l7af�Q`3�]�ݠ�I�VG����l7�f�Q��l7rs��ݨ�I�R<�v#{��FL�ݨ�f���l7�|��F��ݐ�I���vC~G����d�ћO��Fΐ,ۍl���`�l7�y�l7d�{�n6�vSPY��� ig���(:V�y��D#ۍ�tg����e��s|.ۍB�e�QX/ۍ�y�n�vq�vC
�n�+g�Am �nԇ~�ѱ`��ݰeg�QX#����n�8��n��3���礛�FohV�r��f�AǱ���l7%GR����f���Y7��z�g���i��<0�l7�ƙ�!3��n��vC`F����ݼg��G��vC��f�A�N/�zH��X�l7ˤt��l7%�l7�Ηd��G�L�92N��Jʲ�ȭ(�vC��8�jS���T����݀g���F>F����l7���n�eʋ��6+:V=��X��%ѱ�ϣcYe^t�^� :]���X���c��fD����ѱ�F��F�ѱ��K�Hyt����X>��h�bh�̈��]**�7ST�C&*�P����b�;��b�7LQ1}��bz�HEŘ��&*�[e��1�7$*�O KT� ����������j"*�����f�b������b"*�&|"*�/��X������G�'*��'OT� ��L����;i����Cn���$�}ñ��k��\��� �/�ۡG%�v�U�v��O���X�-n5Han��%����˸h��zjD܎����vh+����Ȝ�Aݤ&�C(�vh����г��v��͢�����ɢ��C�A�N�A�f�A�+�J�#k�A��"����� z�ft}2��A��t0)DBJ� ����{`�?D"~���2� �Џ� ��A�E;����%1z��*C:��=:����Aڧ�`�I�n^���٣�@/��D�:xG�Qx�Kn��s��'s��y2.�Q��ˍR�a@O"�0��;�G�� �+St;��MK"o�A"�9�<ex.� ��z@o��3<Z�'�  �����[ex�� ���A(@�->{�=��S����=�y$0� 0H�A@>� �,X��AW�y�ԓ�A�ۓ�A �B�� �%�zP���]<� h�ă��,:�.\��A�?�� �QI<`՟=���h�A {��A ��2�
��gɼ()f4m=5"B��fx$�� Pd�A M�=z@�A~�����{�� ��;@�P���-r���p�+�����p A����"r蹘��13��#��0�� 	)u�Jw��w�^�nTW����F��I�лB�x��\tXt%��$EN5\� �m��o��(��!5�nTY.*�d�Co
�ȑ�!g��)�+�;b�w�`�鈑�yG"���G��8���sG�,D~^��W`�د�,�_�	�_�
egz�W��:2k��z�[��j���m������_n���k��r���~_oժ���u�.�Ͷ�]5�,+z�Ec�CY4��d�$ʐE��yY4	O�H������P��j��ղm�m�h�mS�M�w�$��&ӕ�8�\N�<�uЌ'M�3O�D8�44{2OB�4��=i�;��4��'M�O�^K�'M"O�n��Ic�oȓ&lz�
P�'M/�ؓ�g`�I�}�z�$bƓF��'MsO���44�O�����{�t5�'M"}O�ޞ<OA"�'M/1ד�z���4����'M�N=i`z��qw���7O���'M�J�I���IC%��G#O�SMO�Tg�4=�'LϒyO���44mO=5"OZ��fx�$���Qd�IM�=iz@�'M~�����{����=i��-O�>��'M/[�I���I#W��'M��I�5d�4=�'M��̓���O�ד�!��IH�'MPz�t�x���&��Iį�_�G����K�|�5��'R>p>��Io��+���?��h��s�B�f��f�h�U��.7U_��u��.6M���_�c`�fE�fkV<4[k�e��(�l-1�fk�P;*��nմ��]tպ�������zsLޒ��)��E��sO0�d�Z���Q14�w�qY6����<0���!�V6
�d�`��l��4���<(0��!ae�<���l�x��ϲy�9g��l������ ��,d�e�l�l��CB�y�ߑ��`�,Fݲy��'��gH��C7%��0V6ݼK64՝l�f�(�,��Q�4�y���<�n�e��M̳y�M���gl����l=��Cb�l�d����9�*�g�`���̓�d���f� �`��.(3�����<$���)��V���C����lhF6t��e�`�q�̓��lEGR�ͣ�e���Y/��z�f���i�̓<0�l�ƙ�C@+���<,��`y6��g�y�)��Ye��_H�y�{��̓=$�^,n6�
�2HK��9@B��ie� 's ��� �$s����9@�A�����9 7.��ai� �H;s ��f�eCe@��<s����|~��.�3�]ݬw�fl��Z��vS��f����j�.������X��Ϡ��A�?����$�l���:��mP�h���yC �x�C@�>{
��\��Dϳ��W�cO1�=�y��D�)M��x�{�!b��6��S�saO�x&�=U�,8�2�%E\���U�z-9$�Z"h�$0�k���_�2�eA�g�%FX^K	���t�Z���֑z-��ZR`ⵔ�2���eF^Kt5�y-Q��k�{��D��k)�[^K���~�޼��l�Dec����y-�������Ũ��l>��Rϐ�k���{-��Z��]��h�;^K���X%��^���v��k�w��k���{-���{-��M��`��x-�k��ZJ�㵔8�k�����̽��u����k�-�?O�%�#�%\P�גY�#�%4L�S�%Xu���z^K��^Kt��y-�q�{-��ZI�ײ�y-�u��Z2C��R��ג<0\���qf^K����{-,�Z"X�K{�k�Nt��Bz-��%�w:^K��({��^˒eR:}C������Lpz�<���_���l>�L��O�f���C߶���L�l��]�i�Oݽ�K�����)�枛��d�����A��tVG�²&��7[��auw�; �>/#�q��c,��AXt=,�1<�$��9�$m��"	�/̏$�P7�@"�H	r"	Xe^$�D�H�/�@;:�H��4"	p��HK#	��5�$��04�Q$rG��#	�����8��W0u<Q�����R��d�'    �O�8�04q�`\�x*���x���E�]O�|�x�u��'3O�8���I�����'�_wu<���	�T�9�4m<v<���	����EAF�t8�P����fO�wd.$��b���6���gH�x�M�Oc9�����񄦺�x�Z	<��u<� M�P�	Oz7�O@9-s<Q%)����B���3�'��;�@���x��O��Iog�*�;���:�X��IG��<O`�OpA��'-��9�$p<�(���V��x�����H*�'t��9��q�;�$.��Fԇn�hHu������F�L��n��u�iw\u�Ao�:��؜�pk�}����n:ܺU�7}C:���j�p�Bn�@cn=Cn�>Mt�u|���M��7�CD:��u��p�	��p�p@C�,�X�[W��pK��í�'O�� R���x:ܨw��Kcn]<��֎�D�[��-nt�]t�q�7�Z:�zTn���:ܨ��h��M��,n U�qt��,�����ֹ7�6�7=5"����Q�7E�:�4l�����t�����ֳ����{����}n�p�
�p��N���#C��\�:�z�n��p빈t��\�t�Al��íG���Ð�pKH�������=0�í�5��D�������'x�íA�7�5�:ܤ|	,��f���7��=n����Fh_ �Me Cl*�~��`�Y Ze �6���6R��/� +��o�� We }�����L&�gFe*�����ҨL$gDe��ܨL�uH�2�̞�)�K�LU܌ʤ�K�2),�ʔ�t�2i�r�FT&Q�1�2De���g�O�*
�H�WEX�~���<�
���_頒�~E��\������+bѯ0�_!XN�B��~�e�,��;��f�T�
!�_AU&�~������\�U�2)�����"�O�ґO1�Jj��+=26���n��+���+dѯ�XL�*�Y:�+�gЯ��ӯ�z��W�s���J�IG��"�����c��C��Ej$.0/q���}(.O\�k�$.�3q���� 蚸�O�:��Ef%.��4q��&.���8q�t��H�<q��K�" ��f�"���E�E$.Re��E�l��HAf�ߑ� B�,F����&.�3$K\$�b$."3q�l�5q��^�"�T�$.*@ډ�4A8J\$w�<q�l���Ho�3�����9>��H�g)���H��Er��$."��E���6��E����db�]0N\�����Cĉ���D�?K\�W���H�ӻ���f%."��l�"t���I\Tr$���J�n�"y�u!���E�8�����H�8��Eb&."@#q����H\���\����dFt�"��4q�wz���C����'.*X&��w�]�m���۠��۠���6h�JJm���b�O/�V�I�C�<���<�W����O�����NJ�c�O�� �1�7D�ӛ�E�+@�<�@c���!\^����<��xl+�x��ЄOx�g��b�	x�����<�ޞ<A"$<$=��w�Ҙ����<��Jx�Rg��qw!���70"Z<=*	��3�|��x�V`�y����,�'�igGN�C�� ��S#"��lO��=E�<j47	xz@O�^,��>O�ٚ����"��
�uU��~d�ȕ�J���d���)%�鹈xz.f<`�	xz\���'!�<�AI��=0C������'��~<z�G<�	x���H�������L�!���Oc�x��0�$�q�I��w�8
9ʢ(\hW��p�@�6N.xsYQ���ͣp��Ë�����}���P����
����3Tn�&(��Mp��v����{�6+�e������M�_��[��2#зd���K���Q��[.���-g`d��}���%1w�����[�7�d�o2�S��4�Ř��e5��[�@]�ܞ\�7@"��[.1��Mz���41���[�iS����or�]�ߴp`��?�6�QI��z�_�ߤ��hl��{�m�V8��-��1_�Y"��Zc!7�ic�����6�����"�n��[(3���&l9f��r��o���[�P��-�-3���2�+���-��2k����-�"3˹����13g��#����0d�o)6�j��9�7�O	��
���b��'xl����7��d�`�Y��'2�6d�@�O$C��_d�"�!CQ@��\eȴ�ٓ!Ӂ�L�bɐ��d��bIdȘ�P.C�*�dȴ4	�!C�M���ʐi�C�7.�!ðT�L7Җ!��A�e�tFS�L´��xV%.P`i	]��x�E�R��{�*��.P��q�R��Uh����������
m��������G���'6���'���/_�����%'��~e�u;����V˶m�բi�M=,6U�͉��E1O�*���dw$�/9f�_�.��Ъ��_�v��=��;{`+=	{(%ae� �A��Ͱin1���Z�=�̆=�EW�8l�e]u�jZ�ͪ^��m��nV����L�����
}{N,��������Mx�p�]O�hֱ3�����t<4%&�.dg>i���&q��E\��@���o��!h��F`���&
i���x��K�M�-�7
�迱���#�c0C���7	+�ӛK��&���o�x���{��&&�o�����~C��&��o�l������o2���~G���ZY��鿁�'��3$��M������ͻ迡���Il��VRY��V�4����%�ӻa�����뿁M���36�s|F�M�g��$���8G�Mog�7T0�c������ ���~��o`�����2��$6�c�@�M�S��V����������7t��鿱�8�c8[���HJ�ߊ������z�o��9�����L��<0\�7}���b�!`���`�����o`i�追y�Ѭ����7v�t���C����꿕,���;�(��n }�� ���� zdl7�~%�n ��n tLDn ֦�P*}^:n �l1� ���� x�{n ��97��LyQ>��fE�h����6�$ʇ�y��̋�ыD�����^�a���ٌ(ܸ8���(�H;�WX�bɣ|�)��0���7��&��Y_�R�3��L�3���P��r�3�+��Iyև{Ny�{GJyf��Y�ʠ<3�7Dy�'�Ey.@��g�@cʳ��!�<Wʳ���g��(���Q��U1�<�	�P���Š<��S�u5�E�YoO� ��L����;iLy��Cʳ��$�g}ñ(�踻P�q����,ʳ���V���J>��F�gb�(�� ]�q(�z��S��K/�<�icP��Q�K6��4�"s�3u���g=���mY����lMy�}nQ��	�(�̟&)�`?2(��J�<�a2(����R��\D�g=3ʳ>ff(�z\�3���,!��g�AIy�=0Cy�V���,�R��gz�G�g�)�����H��������!ݍ���Mc��n���0ܤ�q��Iwc���ݠ��Lw���&���o#�/��1DLwC�ߘ������ayt7��� }�i��zد��Z/v�a캮].��f�����W> FX| 	�� t���1 ֑���P`���2>��\���c> *��tϜ� �`���-> �@�� �l�@ec>�������"�Y+�Q7> �|>��!)@7%� ���ͻ��Tw� ��J*�� %H� ?��n��ts> �t}>���) ��>�D��$��H����ř�
�| ��| �������.���2� ��$��qJ� `�Y| �. lh ��s| v�| ��� EGR�(�z| }��� ��9���i� ��o�Y@5�X| �� ��,���=�x':�9�G���/$| v�t� �!Q�bq� %ˤt�����>@�� A   b>�>�|>���_I)@oE1 ��)���J���<[>�>|r>�������o~������      �      x������ � �      �      x������ � �      �   ]   x�%�A� D�5=�Z
�1iP1!A
�Wp�3oJ�W��������M�\S�5)��2;��Ed�&�
ʼ+sg��t08*�f���
� ^7�f      �   �  x��[�nc�r}��eG���c��	:@����x�5cKYv���,�ek{d��LSnK{Y�j-n��\2Wmc�%���)����n����������1�v��|��o����V���r+���a�O�}��?���a��J;{���q��|�>���v_7���|?�������kw�9�M��F��yeV����F��H!ST*�U���D�ZX����vw3=���8�?�����Y.��s�(*
�U�w�X��d�fn��~}�	ф�f�}�TvL���l\��[�\�Y�W}8�����^�=�dr���/m�֟���t�j��vb9����!ǔȞ�0K�Ji�ΑV��zv3�5K��4bv=À_dS�hI.��"9mʯ��#�"+�J#XN��.�����/3ې�2>q\���g�,~��������Ge�[�֪pNa���A?����!\G�/����ސ�%1+o�g��*�ЕY��������Ox��Z[�������^ڌ?�Ko�̺�̥��#㗩��8�P�ǅ�t��Q-E��8����fh��iu���%4��4�*6�s�7�R��V��F���p�x3i{-�hP���9�>�Y>�?oFf��<Xa��J�3�ńAX�S�R�n��m>��>��wub��e���Z�9"�<�`�J�r��SD��/�c�Z8�����:��:����D��N����a�_J�`���TRH)�%]��ƉM��]�?P>;��o����N�=G^yZ ��
�l��,�Ţ]�9�/֩T0���]��q*��:���3�`c�-��ȣ��p�݌p�Ⱦ��Y���������UH�I���4D�!���9
������|!|e*�CՒ���h2�86��*��݋��!���P?&|��S��\���@.���*Gm���IB�eʹ��B����;�hn���:��Վ�}�X/����`�����Sv�T8E�[�6���Z�qY���n�ӏ[~�J�=v��%K²/Xr�A�c�{�����2��L�ZM�@1Ӫ�2����E�O�#�Nsd���1E?�n6#$s�/¸��d�J&�8�$dr�I���C����؝7"uƾ.��ڀ+��GP.�ג�d�<~H�z���v�
�]=��#Ϗi�aء�0о2��xt�b�"~ �=5�_�C�T��ϰ���3>�c>4pi1F�1H�}A����,�F�С�:�N�@k��Z�F��u��RW��@L���F����#���Ъd���^�JSh-�1p����K���3\���7��#k��Q،`�2
oi�ڮ�؆����)����M��l��s�"�n���G��W
�oF����Va��Q%,�Ȫ~bk�X�-d����"���r ��BZ�)S�����EUT4l�%�k��
.��K>��]�x����O��^C�����þ�,�h�0�	~F1vE1�5��}�����c7� ��kg�J�"1$x�f�J���NQ��S�T��E�$eZ�<����m�x�W����c�a���V����=a��X�T����ֈpmD��I9r�-��6zX!~3B0���%�ACG����)Ȍ��G�a�|�G4���A>8����|��۷>�@�������/D��[�D��$ɋ����'
nZ��%1�n�-ļ6�t����,:����(JP'ڢ�BE5�&�)PӾ�8R�?����� ѕd��\B�0�1�&���&�bdG<���_Jf��Z2)�rЬQ��L�bP8f]8� �"�EV1��+�@'�f�K)j�Jq�B�B
��K�� M�Y���l��J2�F#�k�^#CX����ɀ��[��Ȩ�Qڌ]I�4�Z�J�B�4~N�����d�/��C��΢�_c��+ɴ��p۱	%�qŘ~X���_(3kK~��_Jf��J2�UX�H%6�Q�	+j�ў�z��=��Y��Un�,��ȋYh�$˅=�a|�~<�3�NŒC�l\�V։��'-��a�Â1�g_���OSރ�u%L���D����f�)ع,�("0�ү�Skw��K��P�U�0f@/�nc5�)��Ek�7�E��s���/���5e�����or�����ھ밙��M�/'� ���`�~y�oP�FUt�����U��`������Q�1���/O�3W�=0��+�$pDӦJ��g\�,<�OB�O��L���/�VEo�z,͓�*��K�j�WR����xx{φU���A��"$�-_.���|���a�u	��EN��֏!:~/�7���wy�4�k���x<�,����x���@��Sv�t���N�2lf��м����J=�=O�����g5&�3����%2��<��t�%+#� ƌ����ބD͎��oo&�9@��0�P�r��,��6%*��(o1)sA�*��8�~�&ˡ�C�S>����"_́����H���r�0���>����jk�Td@o�UjS~�A�tB}�v���~�2b�����1~Y��F8>���[� �	L���Dp_�Kχm����<����)x��<�0��0��y
�.�a�M��_�H?�ЩE�J)��C����No���9�,���j��ǒjA�<��o3ZYl�My����i>':���Յ�7������m�-r����T،@|� ǵ@RD�C�T�����l��X�3DC���"����v���W� �Ě���.i��ϳ൷�@���(V�^�A�߽+t��s��݄
$���z��%
qQ�@|��GGU�PPĖ� �BM[UR\�8|?�W ^#�^����ٗ�؅T~'C~�R?^��oP����O������ѽ�2a4]_qk5ď>G�y�,�|��2�Jꗔ@GM��L�BJZK�������驪�zw�H�A�=����w\R5#��`�%��j"�y�X29�����[}��G9n�����>����(�a��=.����ձ��F�a۠ck��;���v����m�*����7�Q�9���d~��|��ެ���L�a�87c~p�Qa�j13q'�?&{}#	t�?�ξD�qA# ג���1D���$�V|����.�ޮ ��1���*�v�u���%Rh�Z
�BDL�b��\8)	�4C�g����>�Rxܕ�FIX��;]�y��WK����I���E��T^�������LU;P�[��C~<l��@��&����ZB�E�h}���F2�vA�hgj�Nՠ�Sϱ�*��A���N0�Oky���y�� �h��zI�&�ɖ~fU����`�����͡���	���Q$L��'"�G�p_�_ ��q�E9њK����� 0�?�a���ߩ��������(2[3<9CY`\�.���h^L7�L-�2�V�f��V���"K��M�u6�O�l�&�-���,��hu��A��������}�Q����,�cI6# �e;����"06���dmtS\�a��2���cn��((^ {��r��V�C7��<�[��|Q {ﷻ>D��ɛkʽ�P�s�o/X����߂�vE��ԖsN���t�W��������&�� �!o��E��H{y_Gq�z�	��d�OL!9.��mN�8h����,ҋ��gPA];��̧�非Ea��$8�q�U��\LӤ�aՠ�Y�FEY%����/�Cw8Т���z[�	no�P\���,�+��6(�LyW[�I#|@��Yd����d���5��*fD\�h�(-G�2��_�}�����{�_�
�+n�;?��6#$�4���>�D�JII��OU�����h�9v�̝��.bFA�G�ք�ao)A�B�x(�~�������}7���ϰ:EP�q}�`\���������)�w�"������K��(�����K�r���_�n�^�?�t�2      �      x��][oc9r~���~�J�K�� ���F�,�ږ%G�����SGɔ}Z��{���� =n��ȪS�"O�-�r�}�����_�W7��'�u@�"�,bֆ��%D@S�/w���z�I4_�}�r���/G_��EZ�2�/����B���\�/����Jϥ��]�hv��+�������+mV��^�~�ni3������>������܌��W�:������f��]�n��m��Lv���!]<��1�`��L�e׷�Zv�ȣ�V����og���Hӌ_�ofw�L���b�[o>���~f�׋�����Sd>���ϸ�-
���=�nП�7Lk�~�w���v�X�����t�[��u���@_	efBΤ�U�+����+��ⰱ���q/�$ A�P'0��V�^jg��R���o�͖��Ϗ�����[���q����]���sQ�'�?�X�1���/� ���}]n����7�lW�<����c�9,}P��W���?��a�o��n��ǧ�����~��9.t`j���|}��~�ވ���:��6\.���0��zs���v��}~$;<����j�\���o�ݬH�&蕴�J�x��aN��$�ɩ�3�ΝT&؊<���vw=��l�NX���k}J\5��X�^Z��!X��U��SaUP�����kU�s��$O��C���0�B�����:wRY_+���f��M����'�@̥S�ʗ�'�d�K*��!P��CF������תH�������P���1� F��~�׹���Z�#��
���)2?��ԕ���|�#ϭ�8��$�(B24>Ja����}X�a}��t����?���K����Pa6NG�N��c����bu��>pm-�ȣ�����\���C"���"
��6.2��W]�\�؊|�c+��1RP��4�\��k�B� �f�]�\�؊|�c+�ⱄ��n
B��J�g�����Np�c+�%���ZW$�!������蝧���~�b=�j���F䈮6"+s1�86✁߾	�52G�
����	�xlE��Y�(�'�
G슣Ec�%��C��e4�9��	�xlE��Y����8ФY/�m��"-W��y��<6"GxlD�g�-y��Vj>ȨHQJ�x�@�/;��I-�F��T�aQ�:fK�
�>D�hu R��y��~b^+ŕCU)@i;��A�r�e�a���2K���~�D^۪���v'?A�Ex)}Q���IL�0�ף��d��Zwl��*�̵su8nD�4R[�'Y9��,.�L m��z����8�>���E%�V�H��
=�J���2r��x)|�Ʉ��Q]h��LYu��lFֆ|�/�߆�b&�̤���6�(N"X�i.ւr��D�ʫw/vm4"G"h+tj�1A��A��0C0:(�_�Ak����$��)F�
��M������F�"��U�>��>E�@�Rj�mt	I�������]�%[#�ht�XM֛�0���^���L�YK���	3dy�k�42rM!�c�߹���ֈ�"Z�S-�	2?�e�pe��
ia�%-E����c�M�$�v�G0.�iI7*��ei�YG'�rt12$ee�PP�����Eet�ȣ�mW�_f�~e�l3���<�b�WE��8��8��9+̜����:wQgV�ȣ�np�Y`��͌��f���A*zh�J�!��(�	�Į��4�o��5"��_/���=͔0��	�>E��v���E��ҵg����䐼��h+���͵���� ��U���2�m5�I�{D���Z���-�z��L�.�L#��h��,����f \3�	ۛ"�3m�rx�Ɉ�R:���":B������`8��A���J���Z5�`{�x��O1��H:�� �%j�%Кs4�#)\.���S�>|=%�C�,v󴾻[�>�3$�ƐV̪ʱ�O�U��T�*Cl^�h�l���s���_� �iT2mq�H����H�u��d�%�vC���3�t3�J0ٛʉ�b��'+Xe�X0�h�\�_����i����Sb�:cg��8�L��i�$�`%j �P�t7f�^�L��j�v�+�v"_#��%N��g�����h�$4S�$J9BN�X����"��
�'.¦$ډ���!_#��%N�3ΑM�ȑ�6�+yz�;�QPN��>��Q����	^-�N|]D�!_#��%��L��<���������Bu��'�D��J(���<D�L-VOg,:��P���E+��Q�8�fIC���,�*���l��r�\�эȗ<�"�k$A�g"j�Y	H�M�.�]��g��#g�����*Nۤ��g��EJXk�w9���']�׺ڈ��Fd}�R����R 脞�&������Np�A7"G�Y6"+�I����즌)H��+B�j�_�\��/ylE��(��Ԗ��C"��)�����O�c���F�=6"��Q�C1����yE��T�E�hc�,�����M�U�M�GIf��kٌ��g�I�d(���ªb=����r���YM�UYM���؊;�G��� ,�"�;���dw��]�3}�B�Nۖ8�q���A�`���}�6
CJ�RvIN,G���;�;��c����
���eys��$q�SbB@�Q���:�f��;�u�҇|�[�x&�VX%FQ0�N�dA[�Rh8�Ϭ�Sb���g����c����
���)e�$g����\������N|}J���d����
���L���<6�'�#JNʹ+%���#�N $Ux��>�p!���KIo�L-��׾�xt\n�Og�z���j.���i"Q�|L�޾��N~��/�%��Z�k�+��~��,V�ۯ���md�Y��ǇI�n��V��������$��ax	�&�h���>Nz�<�y�=���F�ɭ��EC0ih�JV��Ԡ_�}�W�x�x�EZa^d��[���-�k�F�|���K�H�>p�5Gg��.�N8|x���^�U�+/ɓ�E�fB���`�JLNE:���>�k�H�ϼH+l�����yND�ӑ9(�f䜔�ám���P|�%��?�ȇ�"��V_{Y�m��R����8�)�'�;�A=�]��y��Y���f������1�ͨ�`�I��|���QxW��^d�\7c��q$n�l�fi�N3)��B]�J�K��	  |��]�+�t0~���k'��Q�G^�����l�w� �_7}�N9	� Mtޓ���7���"O�v��o#��ђ���L�L��e1TJ*�#���!Jd*"K��N�v�+^[�'^K��7;wx3Ӧ�B}0	eʜ`�5nB�C�U�T���[�ק�������ǛL�P3��H��E'\���@�q�'�K���E���N�v�Ͼ}ӆ<eY�E�����L*�L�b�*��Ь:R��0���/��Np�j+��q�������͕R
:�,��*L� E�c`��U�����ksmD��)�����n���fJ�f�k�2;�(1p�J��C�C;� RG�X>��>p�Z��Rv�Y͌���:�*C�ۉ���ʉ������h'�����#�߹�)��l{G���j�P�j\$�rH�r9L�|
d���.�p'��y�#8����a8�y�y�k&q��Ș�	��Gp�/P�9�ɮ\'��w!�zZ	�0��*6�,�
Ip��ђ�ZzN�Z�x^O7�j����h�U ���@�QzN钳�G6��^�v{��S�����c���*� |3��٠�f�pb΢!1kⸯS�ދ��b'f;����F�3��kg�j+�z��}�8���>1�'{ʗS�Np=>lD��>���:Ӝ�����E�%���b`�ef(ő6/���XlD�]��-Vi9���Td3��Պ`uT�#;Kɵ�3!��.kq'�~����Y���V����� ���׫&ȼ������psk<��K�*`�R�
��IO����l΀cs��&�V-���C���c�ix��g���^*x~U�Uu�D��U���^�Y�����KW����� �  �=g�W�_�jT�� M
)�	 ! '�BP�����
�>p]�6"O�o��.���i��:�Ek� E�'�Cn�$g����!�yd�6i?��r<v� �����/&ȼ���nfj}��|���#ߪ3�Ha���`�G�e�2Aq�S�����*I�d9�-ZHYG�Z��ȗ�'�싙m��~+��}e<���}\J�RL,�J(6\f�\�~#�s��lnV��io��Sv?A�v�Jʹp�5r�(
�u��Jb���V�p!g1��a�o��F%9���H\�z�yΤ�Y�F��{qO1�|v�������I�!IH*I@*��9	����=�Np}u�yd���z3̰���,���f�E��>�u.@�BI��c���s��"�|^�7!�7�˒pf����@=\�atE�Bb8��*�im�?��4���F䩒[�l�����;ь>���:j
����*)�(�P��QX'���z�4�^�/sr$R��	Զ��a����Ͼ��Y��r�\�j#����j�����*�L��^�m�n��:��.r��):e���V;���6"O���vG�C�a��h&Q1[Ȳ낔U����E�A�BJ�˦�	>�jچ|:x��W��
��>�zM�yS�%ŕP�Ϣ����� ��*)fp�F�8S�E��G���ԫUIꩁZxOYe�8xy�*�5T���4u��A#��W+�bT+����&��'om���1�H;�;��-�F��+��J{μZIL}�n��[M_��+�9����8W��_�K��q�W��dU)����f��JR��\���T�P ����!7���r"�w������o���tFƧ���x�!
0�&��'_:��4���m�N��� ђ�f����	2o�{y��=	����p���9�E!qďބ�Sb8��a�o��V%�oA�H��2\�1�Z��Ղ_R�l���
T#�v?	���/����O��      �      x������ � �      �      x������ � �      �      x������ � �     