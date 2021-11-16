function m = gpt_snapdragon_2010_green_et_al( m )
%m = gpt_snapdragon_2010_green_et_al( m )
%   Morphogen interaction function.
%   Written at 2016-01-04 14:25:32.
%   GFtbox revision 3502, 2011-04-15 16:29:35.777989.
%   Model last saved to SVN as revision 1779, 2009-10-02 11:46:19.097914.

% The user may edit any part of this function between delimiters
% of the form "USER CODE..." and "END OF USER CODE...".  The
% delimiters themselves must not be moved, edited, deleted, or added.

    if isempty(m), return; end

    fprintf( 1, '%s found in %s\n', mfilename(), which(mfilename()) );

    try
        m = local_setproperties( m );
    catch
    end

    setGlobals();
    realtime = m.globalDynamicProps.currenttime;
    dt = m.globalProps.timestep;

%%% USER CODE: INITIALISATION

    % Summary of the interaction function
    %
    % At input structure m represents the state of the model At t1
    % At output m has been updated to the desired state at t2=t1+dt
    %
    % It is called once for every timestep, dt.
    %
    % m has fields associated with factors, such as morphogens.
    % These are extracted from m, modified, and  re-inserted into m.
    % GFtbox then
    %     a) Relaxes the finite elements model and, in this case
    %        sets residual strains to zero
    %        RICHARD - perhaps some detail - Mention Matlab solver etc.
    %        max_error, etc.
    %     b) Simultaneously evaluates reactions and
    %        relaxes the diffusion system. It uses the same
    %        mesh as the finite elements model.
    %        RICHARD - perhaps some detail - Matlab solver etc.
    %     c) Distorts (grows) the 'cell clones' to reflect the
    %        changes in finite elements model geometry
    % to produce the state of the model At t2.
    %
    % For example,
    %
    % [id_cyc_i,id_cyc_p,id_cyc_a,id_cyc_l] = getMgenLevels( m, 'ID_CYC' );
    % where
    % id_cyc_i, scalar that indexes the CYC morphogen
    % id_cyc_a, scalar where id_cyc_l=id_cyc_p * id_cyc_a
    % id_cyc_p, vector (one element per mesh vertex)
    % id_cyc_l, vector representing levels of CYC factor at each vertex
    %
    % Note: the dot star ( .* ) operator is an element by element multiply
    %
    % The interaction function uses three further functions,
    % listed at the end of this file, pro(), inh(), TimedMult()

    % the following command prevents shearing between the two
    % sides of the mesh
    m = leaf_setproperty( m, 'rectifyverticals', 1 );

    % set colour of polariser gradient arrows
    m=leaf_plotoptions(m,'highgradcolor',[0,0,0],'lowgradcolor',[0,0,0]);
    m=leaf_plotoptions(m,'decorscale',1.5);
    m=leaf_plotoptions(m,'arrowthickness',1.3);

    if m.globalDynamicProps.currentIter==0 % the first iteration
        % set up control of mesh thickness (override GUI)
        % zero monitoring variables
        m.userdata.areas = [];
        m.userdata.times = [];
        % clear the ranges fields and start again
        m.userdata=rmfield(m.userdata,'ranges');
        % Add the range fields
        % The following range of mutants were used in Cui et al 2010
        % in conjunction with the modelnumber range 'WILD'
        m.userdata.ranges.mutantnumber.range(1)=0; % mutantnumber 0 is default
        m.userdata.ranges.mutantnumber.range(2)=1; % mutantnumber 1 no production of polariser from prox (still has background)
        m.userdata.ranges.mutantnumber.range(3)=2; % mutantnumber 2 constituative cenorg
        m.userdata.ranges.mutantnumber.range(4)=3; % mutantnumber 3, dich no longer influence distorg
        m.userdata.ranges.mutantnumber.range(5)=4; % mutantnumber 4, 35S RAD (constitutive rad)
        m.userdata.ranges.mutantnumber.range(6)=5; % mutantnumber 5, backpetals constitutive cyc
        m.userdata.ranges.mutantnumber.range(7)=6; % mutantnumber 6, constitutive cyc constitutive rad
        m.userdata.ranges.mutantnumber.index=1; % default index selects just one of these modulation function options,

        % The following range of submodels were used in Green et al 2010
        m.userdata.ranges.modelnumber.range{1}='Fig 4G Model 1'; % Ground state: triple mutant (cyc, dich, div)
        m.userdata.ranges.modelnumber.range{2}='Fig 4J Model 1'; % Mutant 1  Ground state with no polariser
        m.userdata.ranges.modelnumber.range{3}='Fig 4K Model 1'; % Mutant 2. Ground state without growth inhibited in the medial lobe
        m.userdata.ranges.modelnumber.range{4}='Fig 5F Model 2'; % Double mutant (cyc, dich)
        m.userdata.ranges.modelnumber.range{5}='Fig 6G Model 3'; % First model of wild type
        m.userdata.ranges.modelnumber.range{6}='Fig 7B Model 4'; % one attempt to sort out clonal pattens in 'Fig 6G Model 3'
        m.userdata.ranges.modelnumber.range{7}='Fig 7I Model 5'; % second attempt. Introduction of a central organiser
        m.userdata.ranges.modelnumber.range{8}='Fig 8C Model 6'; % Wild type with improved shape
        m.userdata.ranges.modelnumber.range{9}='Fig 9B Model 7'; % Main Snapdragon model, Wild type with DICH influencing DISTORG
        m.userdata.ranges.modelnumber.range{10}='Fig 9B Model 7M1'; % mutant of 'Fig 9B Model 7'
        m.userdata.ranges.modelnumber.range{11}='Fig 9B Model 7M2'; % mutant of 'Fig 9B Model 7'
        m.userdata.ranges.modelnumber.range{12}='Fig 9B Model 7M3'; % mutant of 'Fig 9B Model 7'
        m.userdata.ranges.modelnumber.range{13}='Fig 9JK Model 8'; % CENORG slightly active in ground state
        m.userdata.ranges.modelnumber.range{14}='WILD'; % used with the mutantnumbers above for Cui et al 2010
        
        %****************************** CHANGE THIS INDEX ******************************
        m.userdata.ranges.modelnumber.index=7; % selects one of these submodels, 
        % change, save, Restart and Stages: Recompute stages
        %****************************** CHANGE THIS INDEX ******************************
        
        
        modelnumber=m.userdata.ranges.modelnumber.range{m.userdata.ranges.modelnumber.index};
        if strcmpi(modelnumber,'WILD') % this is here to hide it from the cluster control system
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CYC','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DICH','mutant',       1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DIV','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CENORG','mutant',     1);
            m=leaf_mgen_modulate(m,'morphogen', 'V_DICHDISTORG','mutant',1);
        end
    end
    m.globalProps.timestep=2.5; %FORCE dt (overriding GUI) since it is so easy to forget
    m = leaf_mgen_plotpriority( m, {'id_cenorg','v_cenorgp','v_cenorgn','id_distorg','id_proxorg'}, [10], [0.19 0.19 0.19 0.5 0.6] );
    modelnumber=m.userdata.ranges.modelnumber.range{m.userdata.ranges.modelnumber.index};

    disp(sprintf('/n>---------------- modelnumber=%s -----------------</n',modelnumber))
    mutantnumber=m.userdata.ranges.mutantnumber.range(m.userdata.ranges.mutantnumber.index);
    disp(sprintf('>>>mutantnumber=%d',mutantnumber));

    m = leaf_allowmutant( m, true );
    switch (modelnumber) % setup the default morphogen activities (0 means zero activity, i.e. mutant)
        case {'Fig 4G Model 1' , 'Fig 4J Model 1', 'Fig 4K Model 1'}
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CYC','mutant',        0);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DICH','mutant',       0);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DIV','mutant',        0);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CENORG','mutant',     1);
            m=leaf_mgen_modulate(m,'morphogen', 'V_DICHDISTORG','mutant',1);
        case 'Fig 5F Model 2'
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CYC','mutant',        0);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DICH','mutant',       0);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DIV','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CENORG','mutant',     1);
            m=leaf_mgen_modulate(m,'morphogen', 'V_DICHDISTORG','mutant',1);
        case {'Fig 6G Model 3','Fig 7B Model 4'}
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CYC','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DICH','mutant',       1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DIV','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CENORG','mutant',     1);
            m=leaf_mgen_modulate(m,'morphogen', 'V_DICHDISTORG','mutant',1);
        case {'Fig 7I Model 5','Fig 7I Model 5M1'}
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CYC','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DICH','mutant',       1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DIV','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CENORG','mutant',     1);
            m=leaf_mgen_modulate(m,'morphogen', 'V_DICHDISTORG','mutant',1);
        case {'Fig 8C Model 6'} % used to be dich effect on distorg NOW add all the twiddles
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CYC','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DICH','mutant',       1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DIV','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CENORG','mutant',     1);
            m=leaf_mgen_modulate(m,'morphogen', 'V_DICHDISTORG','mutant',1);
        case {'Fig 9B Model 7'} % we now add dich effect on distorg
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CYC','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DICH','mutant',       1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DIV','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CENORG','mutant',     1);
            m=leaf_mgen_modulate(m,'morphogen', 'V_DICHDISTORG','mutant',1);
        case {'Fig 9B Model 7M1'}% and now illustrate +organiser instead of -organiser
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CYC','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DICH','mutant',       1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DIV','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CENORG','mutant',     1);
            m=leaf_mgen_modulate(m,'morphogen', 'V_DICHDISTORG','mutant',1);
        case {'Fig 9B Model 7M2'}% triple mutant
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CYC','mutant',        0);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DICH','mutant',       0);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DIV','mutant',        0);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CENORG','mutant',     1);
            m=leaf_mgen_modulate(m,'morphogen', 'V_DICHDISTORG','mutant',1);
        case {'Fig 9JK Model 8'}% triple mutant
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CYC','mutant',        0); % to reproduce Figure
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DICH','mutant',       0);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DIV','mutant',        0);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CENORG','mutant',     1);
            m=leaf_mgen_modulate(m,'morphogen', 'V_DICHDISTORG','mutant',1);
%             m=leaf_mgen_modulate(m,'morphogen', 'ID_CYC','mutant',        1);
%             m=leaf_mgen_modulate(m,'morphogen', 'ID_DICH','mutant',       1);
%             m=leaf_mgen_modulate(m,'morphogen', 'ID_DIV','mutant',        1);
%             m=leaf_mgen_modulate(m,'morphogen', 'ID_CENORG','mutant',     1);
%             m=leaf_mgen_modulate(m,'morphogen', 'V_DICHDISTORG','mutant',1);
        case {'Fig 9B Model 7M3'}% double mutant
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CYC','mutant',        0);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DICH','mutant',       0);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_DIV','mutant',        1);
            m=leaf_mgen_modulate(m,'morphogen', 'ID_CENORG','mutant',     1);
            m=leaf_mgen_modulate(m,'morphogen', 'V_DICHDISTORG','mutant',1);
        otherwise
            error('Selecting modelnumber')
    end
%%% END OF USER CODE: INITIALISATION

%%% SECTION 1: ACCESSING MORPHOGENS AND TIME.
%%% AUTOMATICALLY GENERATED CODE: DO NOT EDIT.

    polariser_i = FindMorphogenRole( m, 'POLARISER' );
    P = m.morphogens(:,polariser_i);
    [kapar_i,kapar_p,kapar_a,kapar_l] = getMgenLevels( m, 'KAPAR' );
    [kaper_i,kaper_p,kaper_a,kaper_l] = getMgenLevels( m, 'KAPER' );
    [kbpar_i,kbpar_p,kbpar_a,kbpar_l] = getMgenLevels( m, 'KBPAR' );
    [kbper_i,kbper_p,kbper_a,kbper_l] = getMgenLevels( m, 'KBPER' );
    [knor_i,knor_p,knor_a,knor_l] = getMgenLevels( m, 'KNOR' );
    [strainret_i,strainret_p,strainret_a,strainret_l] = getMgenLevels( m, 'STRAINRET' );
    [arrest_i,arrest_p,arrest_a,arrest_l] = getMgenLevels( m, 'ARREST' );
    [id_rad_i,id_rad_p,id_rad_a,id_rad_l] = getMgenLevels( m, 'ID_RAD' );
    [id_div_i,id_div_p,id_div_a,id_div_l] = getMgenLevels( m, 'ID_DIV' );
    [id_dich_i,id_dich_p,id_dich_a,id_dich_l] = getMgenLevels( m, 'ID_DICH' );
    [id_cyc_i,id_cyc_p,id_cyc_a,id_cyc_l] = getMgenLevels( m, 'ID_CYC' );
    [id_distorg_i,id_distorg_p,id_distorg_a,id_distorg_l] = getMgenLevels( m, 'ID_DISTORG' );
    [id_lat_i,id_lat_p,id_lat_a,id_lat_l] = getMgenLevels( m, 'ID_LAT' );
    [id_lobe_i,id_lobe_p,id_lobe_a,id_lobe_l] = getMgenLevels( m, 'ID_LOBE' );
    [id_dist_i,id_dist_p,id_dist_a,id_dist_l] = getMgenLevels( m, 'ID_DIST' );
    [v_theta_i,v_theta_p,v_theta_a,v_theta_l] = getMgenLevels( m, 'V_THETA' );
    [id_tube_i,id_tube_p,id_tube_a,id_tube_l] = getMgenLevels( m, 'ID_TUBE' );
    [id_rim_i,id_rim_p,id_rim_a,id_rim_l] = getMgenLevels( m, 'ID_RIM' );
    [id_prox_i,id_prox_p,id_prox_a,id_prox_l] = getMgenLevels( m, 'ID_PROX' );
    [id_lip_i,id_lip_p,id_lip_a,id_lip_l] = getMgenLevels( m, 'ID_LIP' );
    [kpar_i,kpar_p,kpar_a,kpar_l] = getMgenLevels( m, 'KPAR' );
    [kper_i,kper_p,kper_a,kper_l] = getMgenLevels( m, 'KPER' );
    [bendpar_i,bendpar_p,bendpar_a,bendpar_l] = getMgenLevels( m, 'BENDPAR' );
    [bendper_i,bendper_p,bendper_a,bendper_l] = getMgenLevels( m, 'BENDPER' );
    [s_prox_i,s_prox_p,s_prox_a,s_prox_l] = getMgenLevels( m, 'S_PROX' );
    [s_lat_i,s_lat_p,s_lat_a,s_lat_l] = getMgenLevels( m, 'S_LAT' );
    [id_lpb_i,id_lpb_p,id_lpb_a,id_lpb_l] = getMgenLevels( m, 'ID_LPB' );
    [f_seam_i,f_seam_p,f_seam_a,f_seam_l] = getMgenLevels( m, 'F_SEAM' );
    [f_hole_i,f_hole_p,f_hole_a,f_hole_l] = getMgenLevels( m, 'F_HOLE' );
    [f_lat2_i,f_lat2_p,f_lat2_a,f_lat2_l] = getMgenLevels( m, 'F_LAT2' );
    [id_lts_i,id_lts_p,id_lts_a,id_lts_l] = getMgenLevels( m, 'ID_LTS' );
    [s_rad_i,s_rad_p,s_rad_a,s_rad_l] = getMgenLevels( m, 'S_RAD' );
    [s_cenorg_i,s_cenorg_p,s_cenorg_a,s_cenorg_l] = getMgenLevels( m, 'S_CENORG' );
    [id_cenorg_i,id_cenorg_p,id_cenorg_a,id_cenorg_l] = getMgenLevels( m, 'ID_CENORG' );
    [id_med_i,id_med_p,id_med_a,id_med_l] = getMgenLevels( m, 'ID_MED' );
    [v_flower_i,v_flower_p,v_flower_a,v_flower_l] = getMgenLevels( m, 'V_FLOWER' );
    [s_med_i,s_med_p,s_med_a,s_med_l] = getMgenLevels( m, 'S_MED' );
    [s_distorg_i,s_distorg_p,s_distorg_a,s_distorg_l] = getMgenLevels( m, 'S_DISTORG' );
    [id_uptube_i,id_uptube_p,id_uptube_a,id_uptube_l] = getMgenLevels( m, 'ID_UPTUBE' );
    [id_proxorg_i,id_proxorg_p,id_proxorg_a,id_proxorg_l] = getMgenLevels( m, 'ID_PROXORG' );
    [id_plt_i,id_plt_p,id_plt_a,id_plt_l] = getMgenLevels( m, 'ID_PLT' );
    [id_dtl_i,id_dtl_p,id_dtl_a,id_dtl_l] = getMgenLevels( m, 'ID_DTL' );
    [f_seam2_i,f_seam2_p,f_seam2_a,f_seam2_l] = getMgenLevels( m, 'F_SEAM2' );
    [s_lpb_i,s_lpb_p,s_lpb_a,s_lpb_l] = getMgenLevels( m, 'S_LPB' );
    [id_mlobe_i,id_mlobe_p,id_mlobe_a,id_mlobe_l] = getMgenLevels( m, 'ID_MLOBE' );
    [s_dist_i,s_dist_p,s_dist_a,s_dist_l] = getMgenLevels( m, 'S_DIST' );
    [f_seppetals_i,f_seppetals_p,f_seppetals_a,f_seppetals_l] = getMgenLevels( m, 'F_SEPPETALS' );
    [f_sepbase_i,f_sepbase_p,f_sepbase_a,f_sepbase_l] = getMgenLevels( m, 'F_SEPBASE' );
    [f_seplobes1_i,f_seplobes1_p,f_seplobes1_a,f_seplobes1_l] = getMgenLevels( m, 'F_SEPLOBES1' );
    [f_seplobes2_i,f_seplobes2_p,f_seplobes2_a,f_seplobes2_l] = getMgenLevels( m, 'F_SEPLOBES2' );
    [f_seplobes3_i,f_seplobes3_p,f_seplobes3_a,f_seplobes3_l] = getMgenLevels( m, 'F_SEPLOBES3' );
    [f_seam3_i,f_seam3_p,f_seam3_a,f_seam3_l] = getMgenLevels( m, 'F_SEAM3' );
    [f_seam4_i,f_seam4_p,f_seam4_a,f_seam4_l] = getMgenLevels( m, 'F_SEAM4' );
    [f_seamventral_i,f_seamventral_p,f_seamventral_a,f_seamventral_l] = getMgenLevels( m, 'F_SEAMVENTRAL' );
    [f_seamdorsal_i,f_seamdorsal_p,f_seamdorsal_a,f_seamdorsal_l] = getMgenLevels( m, 'F_SEAMDORSAL' );
    [id_early_i,id_early_p,id_early_a,id_early_l] = getMgenLevels( m, 'ID_EARLY' );
    [id_late_i,id_late_p,id_late_a,id_late_l] = getMgenLevels( m, 'ID_LATE' );
    [v_dichdistorg_i,v_dichdistorg_p,v_dichdistorg_a,v_dichdistorg_l] = getMgenLevels( m, 'V_DICHDISTORG' );
    [v_cenorgn_i,v_cenorgn_p,v_cenorgn_a,v_cenorgn_l] = getMgenLevels( m, 'V_CENORGN' );
    [v_cenorgp_i,v_cenorgp_p,v_cenorgp_a,v_cenorgp_l] = getMgenLevels( m, 'V_CENORGP' );

% Mesh type: snapdragon
%            base: 2
%       baserings: 4
%            bowl: 0.2
%          height: 0.2
%          petals: 5
%          radius: 0.5
%      randomness: 0
%           rings: 5
%          strips: 10
%       thickness: 0.1051
%         version: 1

%            Morphogen    Diffusion   Decay   Dilution   Mutant
%            --------------------------------------------------
%                KAPAR         ----    ----       ----     ----
%                KAPER         ----    ----       ----     ----
%                KBPAR         ----    ----       ----     ----
%                KBPER         ----    ----       ----     ----
%                 KNOR         ----    ----       ----     ----
%            POLARISER        0.002     0.1       ----     ----
%            STRAINRET         ----    ----       ----     ----
%               ARREST         ----    ----       ----     ----
%               ID_RAD         ----    ----       ----     ----
%               ID_DIV         ----    ----       ----     ----
%              ID_DICH         ----    ----       ----        0
%               ID_CYC         ----    ----       ----        0
%           ID_DISTORG         ----    ----       ----     ----
%               ID_LAT         ----    ----       ----     ----
%              ID_LOBE         ----    ----       ----     ----
%              ID_DIST         ----    ----       ----     ----
%              V_THETA         ----    ----       ----     ----
%              ID_TUBE         ----    ----       ----     ----
%               ID_RIM         ----    ----       ----     ----
%              ID_PROX         ----    ----       ----     ----
%               ID_LIP         ----    ----       ----     ----
%                 KPAR         ----    ----       ----     ----
%                 KPER         ----    ----       ----     ----
%              BENDPAR         ----    ----       ----     ----
%              BENDPER         ----    ----       ----     ----
%               S_PROX       0.0001     0.1       ----     ----
%                S_LAT        0.001     0.1       ----     ----
%               ID_LPB         ----    ----       ----     ----
%               F_SEAM         ----    ----       ----     ----
%               F_HOLE         ----    ----       ----     ----
%               F_LAT2         ----    ----       ----     ----
%               ID_LTS         ----    ----       ----     ----
%                S_RAD        0.006     0.1       ----     ----
%             S_CENORG        0.002    0.05       ----     ----
%            ID_CENORG         ----    ----       ----     ----
%               ID_MED         ----    ----       ----     ----
%             V_FLOWER         ----    ----       ----     ----
%                S_MED        0.001     0.1       ----     ----
%            S_DISTORG        0.002    0.05       ----     ----
%            ID_UPTUBE         ----    ----       ----     ----
%           ID_PROXORG         ----    ----       ----     ----
%               ID_PLT         ----    ----       ----     ----
%               ID_DTL         ----    ----       ----     ----
%              F_SEAM2         ----    ----       ----     ----
%                S_LPB        0.001     0.1       ----     ----
%             ID_MLOBE         ----    ----       ----     ----
%               S_DIST        0.002    0.05       ----     ----
%          F_SEPPETALS         ----    ----       ----     ----
%            F_SEPBASE         ----    ----       ----     ----
%          F_SEPLOBES1         ----    ----       ----     ----
%          F_SEPLOBES2         ----    ----       ----     ----
%          F_SEPLOBES3         ----    ----       ----     ----
%              F_SEAM3         ----    ----       ----     ----
%              F_SEAM4         ----    ----       ----     ----
%        F_SEAMVENTRAL         ----    ----       ----     ----
%         F_SEAMDORSAL         ----    ----       ----     ----
%             ID_EARLY         ----    ----       ----     ----
%              ID_LATE         ----    ----       ----     ----
%        V_DICHDISTORG         ----    ----       ----     ----
%            V_CENORGN         ----    ----       ----     ----
%            V_CENORGP         ----    ----       ----     ----


%%% USER CODE: MORPHOGEN INTERACTIONS

    % The following are regular expressions
    % At
    % From time
    % Eqn 
    % an isolated ellipsis ...
        
    % Factors are given the following prefixes:
    % ID for identity factor
    % S for signalling factor (most are used only in the set up phase)
    % V for visualation factors (only used for visualisation purposes)
    % F for finite element manipulations

    % NOTE all steps prior to 250hrs are considered as part of the set up
    % phase.


    disp(sprintf('mutant state cyc=%d dich=%d div=%d cenorg=%d dichdistor=%d',...
        id_cyc_a,id_dich_a,id_div_a,id_cenorg_a,v_dichdistorg_a))
    OLD_DIFFUSION = false;
    HOURS_PER_PLASTOCHRON = 10;
    SPACERESCALE = 4;
    pd_offset=0;

    if realtime<340
        id_late_p(:)=0;
        id_early_p(:)=1;
    else
        id_late_p(:)=1;
        id_early_p(:)=0;
    end

    %INITIALISATION
    if realtime==22*HOURS_PER_PLASTOCHRON %23*HOURS_PER_PLASTOCHRON
        m.userdata.all_regions_ready=false; % controls dynamic subdivision
        m.userdata.donesubdivisions=false;
        m.userdata.extra_regions_ready=false;
        fprintf( 1, 'Zeroing morphogens at step %d, time %.3f.\n', ...
            Steps(m), realtime );
        m.morphogens=zeros(size(m.morphogens));
        m.mgen_production(:)=0;
        fprintf( 1, 'Initialising morphogens at step %d, time %.3f.\n', ...
            Steps(m), realtime );

        % First assign factors to regions (vertices) in the finite elements
        % mesh. These are shown in Figures 5 and 6.
        %
        % v_theta is the angle around the z axis.  This is for visualisation
        % purposes and does not model a biological morphogen.
        v_theta_p = atan2( m.nodes(:,2), m.nodes(:,1) )*(0.5/pi);

        % Find all the nodes at the base of the initial flower shape,
        % i.e. those whose z
        % coordinate is less than -0.5/SPACERESCALE.  Set the id_prox morphogen to be 1
        % there.  Since id_prox does not diffuse and is not absorbed, the
        % values set here persist unchanged during development.
        basenodes = m.nodes(:,3) < -0.1801;

        % Find the inner base nodes: those whose radius in the XY plane is
        % less than the maximum.
        xy = m.nodes(:,[1 2]);
        radiisq = sum(xy.*xy,2);
        maxrsq = max(radiisq);
        innerbasenodes = radiisq < 0.20*0.99;
        m.userdata.innerbasenodes=innerbasenodes;

        id_prox_p(basenodes) = 1;
        id_prox_l = id_prox_p;
        m.fixedDFmap( prismIndexes( basenodes ), 3 ) = true;

        % create region to be marked with clones
        v_flower_p=ones(size(v_flower_p));
        v_flower_p(basenodes)=0;

        % Find all the border nodes.
        borderedges = find( m.edgecells(:,2)==0 );
        bordernodes = unique( m.edgeends( borderedges, : ) );
        bordercells = m.edgecells( borderedges, 1 );
        thickbordernodes = unique( m.tricellvxs( bordercells, : ) );

        % Set id_dist to 1 at every node on the distal edge.
        id_dist_p( bordernodes ) = 1;
        id_dist_l = id_dist_p .* id_dist_a;

        maxlatheight = 0.15;
        latrimnodes = intersect( find(m.nodes(:,3) < maxlatheight), bordernodes );
        id_lat_p(:) = 0;
        id_lat_p(latrimnodes) = 1;

        petalborderv_theta = (1:5)*0.2 - 0.5;
        petalmidv_theta = petalborderv_theta - 0.1;
        v_thetatol = 0.002;
        petalbordernodes = false( size(m.nodes,1), 1 );
        petalmidnodes = false( size(m.nodes,1), 1 );
        for i=1:length(v_theta_p)
            th = v_theta_p(i);
            bth = abs(petalborderv_theta-th);
            if any( (bth < v_thetatol) | (1-bth < v_thetatol) )
                petalbordernodes(i) = true;
            end
            mth = abs(petalmidv_theta-th);
            if any( (mth < v_thetatol) | (1-mth < v_thetatol) )
                petalmidnodes(i) = true;
            end
        end
        id_lat_p(petalbordernodes) = 1;
        id_lat_p(innerbasenodes) = 0;
        id_med_p(:) = zeros(size(id_med_p));
        id_med_p(petalmidnodes) = 1;
        id_med_p(innerbasenodes) = 0;
        id_lat_l = id_lat_p .* id_lat_a;
        id_med_l = id_med_p .* id_med_a;

        lobenodes = m.nodes(:,3) > -0.05;
        id_lobe_p(lobenodes) = 1;
        % the levels of clamped nodes (vertices) cannot change during
        % simulation
        m.morphogenclamp(lobenodes,id_lobe_i) = 1;

        id_tubenodes = m.nodes(:,3) <-0.03 & m.nodes(:,3) > - 0.18;
        id_tube_p(id_tubenodes) = 1;
        m.morphogenclamp(id_tubenodes,id_tube_i) = 1;

        id_lipnodes = m.nodes(:,3) > pd_offset-0.11 & m.nodes(:,3) < pd_offset+0.02;
        id_lip_p(id_lipnodes) = 1;
        m.morphogenclamp(id_lipnodes,id_lip_i) = 1;

        id_rimnodes = m.nodes(:,3) > pd_offset-0.07 & m.nodes(:,3) < pd_offset-0.03;
        id_rim_p(id_rimnodes) = 1;
        m.morphogenclamp(id_rimnodes,id_rim_i) = 1;

        % set up the seams ready for dissection
        %         % (adult petals are dissected and flattened - Figures 5 and 6)
        %         lobe_base_nodes = m.nodes(:,3) < -0.03 & m.nodes(:,3) > -0.05;
        %         f_seam_p(id_tube_p>0)=1;
        %         f_seam_p(id_lip_p>0)=1;
        %         f_seam_p=f_seam_p.*id_lat_p;
        %         f_seam_p(lobe_base_nodes)=1;
        %         basenodes2 = m.nodes(:,3)< -0.17 & m.nodes(:,3) > -0.2;
        %         f_seam_p(basenodes2) = 1;
        %         m.morphogenclamp(f_seam_p>0.5,f_seam_i) = 1;
        %         % use m.edgeends, m.seams, m.nodes
        %         % find nodes to be included in seams
        %         seamnodes=find(f_seam_p>0.5);
        %         % find edges joining the nodes
        %         jn=[];
        %         for i=1:length(m.edgeends)
        %             ind=intersect(seamnodes,m.edgeends(i,:));
        %             if length(ind)==2
        %                 jn(end+1)=i;
        %             end
        %         end
        %         % set seams
        %         m.seams=false(size(m.edgeends,1),1);
        %         m.seams(jn)=true;
        %         % use f_seam as a marker
        % set up the seams ready for dissection
        % (adult petals are dissected and flattened - Figures 5 and 6)
        f_seppetals_p(id_tube_p>0)=1; % all tube
        f_seppetals_p(id_lip_p>0)=1; % all lip
        f_seppetals_p=f_seppetals_p.*id_lat_p; % separate petals
        id_rimnodes = m.nodes(:,3) > pd_offset-0.01 & m.nodes(:,3) < pd_offset+0.01; % cut off lobes
        f_seplobes1_p(id_rimnodes)=1; % separate lobes from tube
        id_rimnodes = m.nodes(:,3) > pd_offset-0.060 & m.nodes(:,3) < pd_offset-0.035; % cut off lobes
        f_seplobes2_p(id_rimnodes)=1; % separate lobes from tube
        id_rimnodes = m.nodes(:,3) > pd_offset-0.085 & m.nodes(:,3) < pd_offset-0.065; % cut off lobes
        f_seplobes3_p(id_rimnodes)=1; % separate lobes from tube
        basenodes2 = m.nodes(:,3)< -0.17 & m.nodes(:,3) > -0.2;
        f_sepbase_p(basenodes2) = 1; % separate tube from base
        %m=leaf_set_seams(m,f_seam_p);
        % use f_seam as a marker

        % activate id_dich in dorsal domain
        id_dich_p=zeros(size(id_dich_p));
        id_dichnodes = (m.nodes(:,1) < -1.70/SPACERESCALE) & ~m.userdata.innerbasenodes;
        id_dich_p(id_dichnodes) = 1;
        id_dich_l=id_dich_p.*id_dich_a;

        % activate id_cyc in dorsal domain
        id_cyc_p=zeros(size(id_cyc_p));
        id_cycnodes = (m.nodes(:,1) < -0.153) & ~m.userdata.innerbasenodes;
        id_cyc_p(id_cycnodes) = 1;
        id_cyc_l=id_cyc_p.*id_cyc_a;

    else
        if realtime>=240 && realtime<250 % over this initialisation phase
            % shrink the lobes (part of the startup process that ensures
            % triangles will not get too elongated during growth
            shrinkrate=-0.01;
            kapar_p=zeros(size(kapar_l));
            kbpar_p=zeros(size(kapar_l));
            kaper_p=zeros(size(kapar_l));
            kbper_p=zeros(size(kapar_l));
            kapar_p=shrinkrate.*pro(15,id_dtl_l.*inh(0.5, id_med_l));
            kbpar_p=shrinkrate.*pro(20,id_dtl_l.*inh (0.5, id_med_l));
        end
        disp(sprintf('\n cyc=%d dich=%d div=%d cenorg=%d v_dichdistorg=%d\n',...
            id_cyc_a,id_dich_a,id_div_a,id_cenorg_a,v_dichdistorg_a));
        %Induce sectors at 340hrs
        if (340>realtime-dt) && (340<realtime+dt)
            m = leaf_makesecondlayer( m, ...  % This function adds biological cells.
                'mode', 'each', ...  % Make biological cells randomly scattered over the flower.
                'relarea', 1/16000, ...   % Each cell has area was 1/16000 of the initial area of the flower.
                'probpervx', 'V_FLOWER', ... % induce transposed cells over whole corolla
                'numcells',4500,...%number of cells (that will become clones)
                'sides', 6, ...  % Each cell is approximated as a 6-sided regular polygon.
                'colors', [0.5 0.5 0.5], ...  % Default colour is gray but
                'colorvariation',1,... % Each cell is a random colour
                'add', true );  % These cells are added to any cells existing alread
        end


        % Setup should be common to all the models
        % Start setup
        if abs(realtime - 240) <0.5*dt %At 240 hrs
            %id_prox is fixed according to s_prox levels
            id_prox_p = 2*s_prox_l;
            id_prox_l = id_prox_p .* id_prox_a;

            %expression domain of id_lip established
            id_lip_p=zeros(size(id_lip_p));
            id_lipnodes = m.nodes(:,3) > pd_offset-0.095 & m.nodes(:,3) < pd_offset+0.01;
            id_lip_p(id_lipnodes) = 1;
            id_lip_l = id_lip_p * id_lip_a;
            m.morphogenclamp(id_lipnodes,id_lip_i) = 1;

            %expression domain of id_uptube established
            id_uptubenodes = m.nodes(:,3) > pd_offset-0.085 & m.nodes(:,3) < pd_offset-0.055;
            id_uptube_p(id_uptubenodes) = 1;
            id_uptube_l = id_uptube_p * id_uptube_a;

            %expression domain of id_lpb established
            id_lpbnodes = m.nodes(:,3) > pd_offset -0.03 & m.nodes(:,3) < pd_offset+0.01;
            id_lpb_p(id_lpbnodes) = 1;
            m.morphogenclamp(id_lpbnodes,id_lpb_i) = 1;

            %expression domain of id_mlobe established
            id_mlobenodes = m.nodes(:,3) > pd_offset -0.005 & m.nodes(:,3) < pd_offset+0.03;
            id_mlobe_p(id_mlobenodes) = 1;
            m.morphogenclamp(id_mlobenodes,id_mlobe_i) = 1;

            %expression domain of id_rim established
            id_rim_p=zeros(size(id_rim_p));
            id_rimnodes = m.nodes(:,3) > pd_offset-0.055 & m.nodes(:,3) < pd_offset-0.035;
            id_rim_p(id_rimnodes) = 1;
            id_rim_l = id_rim_p * id_rim_a;
            m.morphogenclamp(id_rimnodes,id_rim_i) = 1;

            %expression domain of id_tube established
            id_tube_p=zeros(size(id_tube_p));
            id_tubenodes = m.nodes(:,3)<= pd_offset-0.055 & m.nodes(:,3) > - 0.18;
            id_tube_p(id_tubenodes) = 1;
            id_tube_l = id_tube_p * id_tube_a;
            m.morphogenclamp(id_tubenodes,id_tube_i) = 1;

            %expression domain of id_lobe established
            id_lobe_p=zeros(size(id_lobe_p));
            id_lobenodes = m.nodes(:,3) >= pd_offset -0.055;%-0.035
            id_lobe_p(id_lobenodes) = 1;
            id_lobe_l = id_lobe_p * id_lobe_a;
            m.morphogenclamp(id_lobenodes,id_lobe_i) = 1;

        end
        % s_prox is activated by id_prox
        m.mgen_production(:,s_prox_i) = 0.1 * id_prox_l;

        % s_lpb is activated by id-lpb
        m.mgen_production(:,s_lpb_i) = 0.1 * id_lpb_l.*id_med_l;

        % s_lat is activated by id_lat
        m.mgen_production(:,s_lat_i) = 0.1 * id_lat_l;

        %s_med is activated by id_med
        m.mgen_production(:,s_med_i) = 0.1 * id_med_l; %

        if abs(realtime - 245) <0.5*dt % At 245 hrs
            %id_lat is fixed according to s_lat levels
            id_lat_p = 2.5*s_lat_l;

            %id_med is fixed according to s_med levels
            id_med_p = 2.5*s_med_l;

            id_plt_p=id_tube_l.*id_lip_l;
            id_plt_l=id_plt_p.*id_plt_a;

            id_lip_p=id_lobe_l.*id_lip_l;
            id_lip_l=id_lip_p.*id_lip_a;

            m.userdata.extra_regions_ready=true;

            id_dtl_p=id_lobe_l.*inh(10,id_lip_l);
            id_dtl_l=id_dtl_p.*id_dtl_a;
            % set up the seams ready for dissection
            % (adult petals are dissected and flattened - Figures 5 and 6)
            id_rimnodes = m.nodes(:,3) > pd_offset-0.01 & m.nodes(:,3) < pd_offset+0.01; % cut off lobes
            f_seplobes1_p(id_rimnodes)=1; % separate lobes from tube
            %m=leaf_set_seams(m,f_seam_p);
            ind_mid=s_lat_p<0.18;
            f_seam2_p(ind_mid)=1; % all elements around mid
            ind_mid=s_lat_p<0.10;
            f_seam3_p(ind_mid)=1; % all elements around mid
            ind_vent_lat=s_rad_p>0.02 & s_rad_p<0.06;
            f_seam4_p(ind_vent_lat)=1; % all elements ventral side of laterals
            ind_vent_lat=s_rad_p<=0.04;
            f_seamventral_p(ind_vent_lat)=1;
            ind_dorsal_lat=s_rad_p>0.47;
            f_seamdorsal_p(ind_dorsal_lat)=1;
        end
        v_dichdistorg_p(:)=1; % visualisation
        % End setup

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%  START INDIVIDUAL MODELS %%%%%%%%%%%%%%%%%%%%%%
        
        if strcmpi(modelnumber,'Fig 4G Model 1')
                        % START POLARISER section (it is slightly mixed with gene networks)
            m = leaf_mgen_conductivity( m, 's_distorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_distorg', 0.05);  % it will not decay everywhere
            m.globalProps.mingradient=0.01; % this ensures that all polariser gradients are frozen
            m = leaf_mgen_conductivity( m, 'Polariser', 0.002);% diffusion constant WAS 0.001
            m = leaf_mgen_dilution( m, 'Polariser', false );% it will not dilute with growth
            m = leaf_mgen_absorption( m, 'Polariser', 0.1);  % it will not decay everywhere

            %\latex \subsection{PRN}
            % POLARISER PRODUCTION
            if realtime>230 % From time 230  generate polariser
                id_proxorg_p = (id_prox_l >0.8);                                             % Eqn 2  CHECKED
                id_proxorg_l = id_proxorg_p * id_proxorg_a;
            end

            % POLARISER DECAY
            % switch on distorg with id_dist in the absence of id_lat
            if abs(realtime - 230) <0.5*dt % At time 230 hrs
                id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l);%  CHECKED % Eqn 3 (used in production equation)
                id_distorg_l = id_distorg_p * id_distorg_a;
                m.userdata.all_regions_ready=true;
            end

            m.mgen_production(:,polariser_i) =  0.1 * (id_proxorg_l + 1 -  P .* id_distorg_l);    % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE

            % LATER MODULATION OF DISTORG AND DIST
            % s_dist is activated by id_dist
            m.mgen_production(:,s_dist_i) = 0.1 * id_dist_l.* inh (100, id_lat_l);          % Eqn 17  CHECKED

            % s_distorg is activated by id_distorg
            m.mgen_production(:,s_distorg_i) = 0.1 * id_distorg_l ;                         % Eqn 15 (but  CHECKED
            % note that distorg is set elsewhere) the 0.1 seems to be an error

            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                id_distorg_p = s_distorg_l;                                                 % Eqn 12  CHECKED
                id_distorg_l = id_distorg_p .* id_distorg_a;
                id_dist_p = s_dist_l;                                                       % Eqn 13  CHECKED (NOT NEEDED IN THIS MODEL)
                id_dist_l = id_dist_p .* id_dist_a;
            end
            %\latex \subsection{KRN}
            % GROWTH MODEL BEGINS HERE
            if realtime >= 250 && realtime<570
                % Background growth parallel to the polariser  Eqn 200

                Kpar=... % Eqn 260
                    0.013 ... % Background growth parallel to the polariser  Eqn 200
                    .* inh (0.2, id_prox_l)... %keeps base small  Eqn 24 CHECKED
                    .* pro (0.4,id_tube_l .* inh (100, id_plt_l))... %promote growth of tube  Eqn 25 CHECKED
                    .* pro (1.4, id_early_p .* id_lip_l)... .*inh (100, id_rad_l.* inh(100, id_dich_l.* id_lat_l)))... %form lower face   Eqn 30 CHECKED
                    .* inh (10,  id_early_p .* id_rim_l )... %inhibit rim to help with bending back    Eqn 32  CHECKED
                    .* inh (0.5, id_late_p .* id_med_l.* id_lobe_l)... %reduce growth of midlobe   Eqn 38  CHECKED
                    ;
                % Background growth normal to the polariser   Eqn 201

                Kper=... % Eqn 250                     
                    0.0075  ... % Background growth normal to the polariser   Eqn 201
                    .* inh (0.2, id_prox_l)... %keep base small   Eqn 43  CHECKED
                    .* pro(2, id_early_p .* id_dist_l .* inh (20, id_lat_l))... %  widen distal lobe    Eqn 46 CHECKED
                    .* pro (1,   id_late_p .* id_dist_l )... .* pro (1.2, (id_cyc_l + id_div_l)))... % increase width of distal lobe   Eqn 49  CHECKED
                    .* inh (0.3, id_late_p .* id_lobe_l .* id_med_l)... %keep medial lobe narrow   Eqn 50  CHECKED
                    ;

                % compute the growth rates
                kapar=Kpar ; % Eqn 300
                kbpar=Kpar ;% Eqn 310
                kaper=Kper ;% Eqn 320
                kbper=Kper ;% Eqn 330
                knor =0.003; % thickness tracks model using Scaled USE KNOR(anti-curl) Eqn 305
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
        elseif strcmpi(modelnumber,'Fig 4J Model 1') % turn off polariser gradient
            % START POLARISER section (it is slightly mixed with gene networks)
            m = leaf_mgen_conductivity( m, 's_distorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_distorg', 0.05);  % it will not decay everywhere
            m.globalProps.mingradient=0.01; % this ensures that all polariser gradients are frozen
            m = leaf_mgen_conductivity( m, 'Polariser', 0.002);% diffusion constant WAS 0.001
            m = leaf_mgen_dilution( m, 'Polariser', false );% it will not dilute with growth
            m = leaf_mgen_absorption( m, 'Polariser', 0.1);  % it will not decay everywhere

            %\latex \subsection{PRN (changes)}
            % POLARISER PRODUCTION
            if realtime>230 % From time 230  generate polariser
                id_proxorg_p = (id_prox_l >0.8);                                             % Eqn 2  CHECKED
                id_proxorg_l = id_proxorg_p * id_proxorg_a;
                m.mgen_production(:,polariser_i) = 0; %0.1 * id_proxorg_l + 0.1;    % Eqn 18 and 19 production parts of  CHECKED
            end

            % POLARISER DECAY
            % switch on distorg with id_dist in the absence of id_lat
            if abs(realtime - 230) <0.5*dt % At time 230 hrs
                id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l);%  CHECKED % Eqn 3 (used in production equation)
                id_distorg_l = id_distorg_p * id_distorg_a;
                m.userdata.all_regions_ready=true;
            end

            m.mgen_production(:,polariser_i) = 0; %m.mgen_production(:,polariser_i) ...
            %- 0.1 * P .* id_distorg_l;                                           % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE

            % LATER MODULATION OF DISTORG AND DIST
            % s_dist is activated by id_dist
            m.mgen_production(:,s_dist_i) = 0.1 * id_dist_l.* inh (100, id_lat_l);          % Eqn 17  CHECKED

            % s_distorg is activated by id_distorg
            m.mgen_production(:,s_distorg_i) = 0.1 * id_distorg_l ;                         % Eqn 15 (but  CHECKED
            % note that distorg is set elsewhere) the 0.1 seems to be an error

            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                id_distorg_p = s_distorg_l;                                                 % Eqn 12  CHECKED
                id_distorg_l = id_distorg_p .* id_distorg_a;
                id_dist_p = s_dist_l;                                                       % Eqn 13  CHECKED (NOT NEEDED IN THIS MODEL)
                id_dist_l = id_dist_p .* id_dist_a;
            end

            %\latex \subsection{KRN (changes)}
            % GROWTH MODEL BEGINS HERE
            if realtime >= 250 && realtime<570  % Between time 250 570
                % Background growth parallel to the polariser  Eqn 200

                Kpar=... % Eqn 260
                    0.013 ... % Background growth parallel to the polariser  Eqn 200
                    .* inh (0.2, id_prox_l)... %keeps base small  Eqn 24 CHECKED
                    .* pro (0.4,id_tube_l .* inh (100, id_plt_l))... %promote growth of tube  Eqn 25 CHECKED
                    .* pro (1.4, id_early_p .* id_lip_l)... .*inh (100, id_rad_l.* inh(100, id_dich_l.* id_lat_l)))... %form lower face   Eqn 30 CHECKED
                    .* inh (10,  id_early_p .* id_rim_l )... %inhibit rim to help with bending back    Eqn 32  CHECKED
                    .* inh (0.5, id_late_p .* id_med_l.* id_lobe_l)... %reduce growth of midlobe   Eqn 38  CHECKED
                    ;
                % Background growth normal to the polariser   Eqn 201

                Kper=... % Eqn 250
                    0.0075 ... % Background growth normal to the polariser   Eqn 201
                    .* inh (0.2, id_prox_l)... %keep base small   Eqn 43  CHECKED
                    .* pro(2, id_early_p .* id_dist_l .* inh (20, id_lat_l))... %  widen distal lobe    Eqn 46 CHECKED
                    .* pro (1,   id_late_p .* id_dist_l )... .* pro (1.2, (id_cyc_l + id_div_l)))... % increase width of distal lobe   Eqn 49  CHECKED
                    .* inh (0.3, id_late_p .* id_lobe_l .* id_med_l)... %keep medial lobe narrow   Eqn 50  CHECKED
                    ;

                % compute the growth rates
                kapar=Kpar ; % Eqn 300
                kbpar=Kpar ;% Eqn 310
                kaper=Kper ;% Eqn 320
                kbper=Kper ;% Eqn 330
                knor =0.003; % thickness tracks model using Scaled USE KNOR(anti-curl) Eqn 305
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
        elseif strcmpi(modelnumber,'Fig 4K Model 1') % This was copied from Fig 4G Model 1 and Eqn 38 and 50 commented out
            % START POLARISER section (it is slightly mixed with gene networks)
            m = leaf_mgen_conductivity( m, 's_distorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_distorg', 0.05);  % it will not decay everywhere
            m.globalProps.mingradient=0.01; % this ensures that all polariser gradients are frozen
            m = leaf_mgen_conductivity( m, 'Polariser', 0.002);% diffusion constant WAS 0.001
            m = leaf_mgen_dilution( m, 'Polariser', false );% it will not dilute with growth
            m = leaf_mgen_absorption( m, 'Polariser', 0.1);  % it will not decay everywhere

            %\latex \subsection{PRN (changes)}
            % POLARISER PRODUCTION
            if realtime>230 % From time 230  generate polariser
                id_proxorg_p = (id_prox_l >0.8);                                             % Eqn 2  CHECKED
                id_proxorg_l = id_proxorg_p * id_proxorg_a;
            end

            % POLARISER DECAY
            % switch on distorg with id_dist in the absence of id_lat
            if abs(realtime - 230) <0.5*dt % At time 230 hrs
                id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l);%  CHECKED % Eqn 3 (used in production equation)
                id_distorg_l = id_distorg_p * id_distorg_a;
                m.userdata.all_regions_ready=true;
            end

            m.mgen_production(:,polariser_i) =  0.1 * (id_proxorg_l + 1 - P .* id_distorg_l);    % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE

            % LATER MODULATION OF DISTORG AND DIST
            % s_dist is activated by id_dist
            m.mgen_production(:,s_dist_i) = 0.1 * id_dist_l.* inh (100, id_lat_l);          % Eqn 17  CHECKED

            % s_distorg is activated by id_distorg
            m.mgen_production(:,s_distorg_i) = 0.1 * id_distorg_l ;                         % Eqn 15 (but  CHECKED
            % note that distorg is set elsewhere) the 0.1 seems to be an error

            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                id_distorg_p = s_distorg_l;                                                 % Eqn 12  CHECKED
                id_distorg_l = id_distorg_p .* id_distorg_a;
                id_dist_p = s_dist_l;                                                       % Eqn 13  CHECKED (NOT NEEDED IN THIS MODEL)
                id_dist_l = id_dist_p .* id_dist_a;
            end
            %\latex \subsection{KRN (changes)}

            % GROWTH MODEL BEGINS HERE
            if realtime >= 250 && realtime<570  % Between time 250 570
                % Background growth parallel to the polariser  Eqn 200

                Kpar=... % Eqn 260
                    0.013 ... % Background growth parallel to the polariser  Eqn 200
                    .* inh (0.2, id_prox_l)... %keeps base small  Eqn 24 CHECKED
                    .* pro (0.4,id_tube_l .* inh (100, id_plt_l))... %promote growth of tube  Eqn 25 CHECKED
                    .* pro (1.4, id_early_p .* id_lip_l)... .*inh (100, id_rad_l.* inh(100, id_dich_l.* id_lat_l)))... %form lower face   Eqn 30 CHECKED
                    .* inh (10,  id_early_p .* id_rim_l )... %inhibit rim to help with bending back    Eqn 32  CHECKED
                    ... .* inh (0.5, id_late_p .* id_med_l.* id_lobe_l)... %reduce growth of midlobe   Eqn 38  CHECKED
                    ;
                % Background growth normal to the polariser   Eqn 201

                Kper=... % Eqn 250
                    0.0075 ... % Background growth normal to the polariser   Eqn 201
                    .* inh (0.2, id_prox_l)... %keep base small   Eqn 43  CHECKED
                    .* pro(2, id_early_p .* id_dist_l .* inh (20, id_lat_l))... %  widen distal lobe    Eqn 46 CHECKED
                    .* pro (1,   id_late_p .* id_dist_l )... .* pro (1.2, (id_cyc_l + id_div_l)))... % increase width of distal lobe   Eqn 49  CHECKED
                    ... .* inh (0.3, id_late_p .* id_lobe_l .* id_med_l)... %keep medial lobe narrow   Eqn 50  CHECKED
                    ;

                % compute the growth rates
                kapar=Kpar ; % Eqn 300
                kbpar=Kpar ;% Eqn 310
                kaper=Kper ;% Eqn 320
                kbper=Kper ;% Eqn 330
                knor =0.003; % thickness tracks model using Scaled USE KNOR(anti-curl) Eqn 305
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
        elseif strcmpi(modelnumber,'Fig 5F Model 2')
                        % P EQUATIONS
            % START POLARISER section (it is slightly mixed with gene networks)
            m = leaf_mgen_conductivity( m, 's_distorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_distorg', 0.05);  % it will not decay everywhere
            m.globalProps.mingradient=0.01; % this ensures that all polariser gradients are frozen
            m = leaf_mgen_conductivity( m, 'Polariser', 0.002);% diffusion constant WAS 0.001
            m = leaf_mgen_dilution( m, 'Polariser', false );% it will not dilute with growth
            m = leaf_mgen_absorption( m, 'Polariser', 0.1);  % it will not decay everywhere

            %\latex \subsection{PRN (changes)}
            % POLARISER PRODUCTION
            if realtime>230 % From time 230  generate polariser
                id_proxorg_p = (id_prox_l >0.8);                                             % Eqn 2  CHECKED
                id_proxorg_l = id_proxorg_p * id_proxorg_a;
            end

            % POLARISER DECAY
            % switch on distorg with id_dist in the absence of id_lat
            if abs(realtime - 230) <0.5*dt % At time 230 hrs
                id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l);%  CHECKED % Eqn 3 (used in production equation)
                id_distorg_l = id_distorg_p * id_distorg_a;
                m.userdata.all_regions_ready=true;
            end

            m.mgen_production(:,polariser_i) =  0.1 * (id_proxorg_l + 1 - P .* id_distorg_l);    % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE

            % LATER MODULATION OF DISTORG AND DIST
            % s_dist is activated by id_dist
            m.mgen_production(:,s_dist_i) = 0.1 * id_dist_l.* inh (100, id_lat_l);          % Eqn 17  CHECKED

            % s_distorg is activated by id_distorg
            m.mgen_production(:,s_distorg_i) = 0.1 * id_distorg_l ;                         % Eqn 15 (but  CHECKED
            % note that distorg is set elsewhere) the 0.1 seems to be an error

            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                id_distorg_p = s_distorg_l;                                                 % Eqn 12  CHECKED
                id_distorg_l = id_distorg_p .* id_distorg_a;
                id_dist_p = s_dist_l;                                                       % Eqn 13  CHECKED (NOT NEEDED IN THIS MODEL)
                id_dist_l = id_dist_p .* id_dist_a;
            end
            % End Polariser
            %\latex \subsection{GRN (changes)}

            id_div_p(:)=1;

            % End Gene Networks
            %\latex \subsection{KRN (changes)}
            if realtime >= 250 && realtime<570  % Between time 250 570
                % Background growth parallel to the polariser  Eqn 200
                Kpar=... % Eqn 260
                    0.013 ... % Background growth parallel to the polariser  Eqn 200
                    .* inh (0.2, id_prox_l)... %keeps base small                                  Eqn 24 CHECKED
                    .* pro (0.4,id_tube_l .* inh (100, id_plt_l))... %promote growth of tube      Eqn 25 CHECKED
                    .* pro (1.4, id_early_p .* id_lip_l )... .*inh (100, id_rad_l.* inh(100, id_dich_l.* id_lat_l)))... %form lower face   Eqn 30
                    .* inh (10,  id_early_p .* id_rim_l )... %inhibit rim to help with bending back    Eqn 32  CHECKED
                    .* inh (0.5, id_late_p .* id_med_l.* id_lobe_l)... %reduce growth of midlobe       Eqn 38  CHECKED
                    ...
                    .* pro (2.4, id_early_p .* id_div_l.*id_plt_l )... %make lower tube arch over      Eqn 31  CHECKED
                    ;

                %AKapar=0.06* (id_early_p .* id_rim_l) .*  (1.2*id_div_l); % bend back petals   Eqn 36  CHECKED

                % Background growth normal to the polariser   Eqn 201
                Kper=... % Eqn 250
                    0.0075 ... % Background growth normal to the polariser   Eqn 201
                    .* inh (0.2, id_prox_l)... %keep base small                                             Eqn 43 CHECKED
                    .* pro(2, id_early_p .* id_dist_l .* inh (20, id_lat_l))... %  widen distal lobe        Eqn 46 CHECKED
                    .* inh (0.3, id_late_p .* id_lobe_l .* id_med_l)... %keep medial lobe narrow            Eqn 50  CHECKED
                    ...
                    .* pro (1,   id_late_p .* id_dist_l .* pro (1.2, id_div_l))... % increase width of distal lobe   Eqn 49  CHECKED CHANGED
                    .* inh (1, id_late_p .* id_div_l .* inh(10, id_lobe_l))... .* inh (2,id_lpb_l)).* pro(1, id_plt_l))...  %narrow ventral petals    Eqn 51 CHECKED NOW REPLACE DTL BY LOBE
                    ;

                % compute the growth rates
                kapar=Kpar ...% Eqn 300
                    + 0.06* (id_early_p .* id_rim_l) .*  (1.2*id_div_l); % Eqn 301
                kbpar=Kpar ;% Eqn 310
                kaper=Kper ;% Eqn 320
                kbper=Kper ;% Eqn 330
                knor =0.003; % thickness tracks model using Scaled USE KNOR(anti-curl) Eqn 305
            end

        elseif strcmpi(modelnumber,'Fig 6G Model 3')
            %             % P EQUATIONS
            % START POLARISER section (it is slightly mixed with gene networks)
            m = leaf_mgen_conductivity( m, 's_distorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_distorg', 0.05);  % it will not decay everywhere
            m.globalProps.mingradient=0.01; % this ensures that all polariser gradients are frozen
            m = leaf_mgen_conductivity( m, 'Polariser', 0.002);% diffusion constant WAS 0.001
            m = leaf_mgen_dilution( m, 'Polariser', false );% it will not dilute with growth
            m = leaf_mgen_absorption( m, 'Polariser', 0.1);  % it will not decay everywhere

            %\latex \subsection{PRN (changes)}
            % POLARISER PRODUCTION
            if realtime>230 % From time 230  generate polariser
                id_proxorg_p = (id_prox_l >0.8);                                             % Eqn 2  CHECKED
                id_proxorg_l = id_proxorg_p * id_proxorg_a;
            end

            % POLARISER DECAY
            % switch on distorg with id_dist in the absence of id_lat
            if abs(realtime - 230) <0.5*dt % At time 230 hrs
                id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l);%  CHECKED % Eqn 3 (used in production equation)
                id_distorg_l = id_distorg_p * id_distorg_a;
                m.userdata.all_regions_ready=true;
            end

            m.mgen_production(:,polariser_i) = 0.1 * (id_proxorg_l + 1 - P .* id_distorg_l);                                           % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE

            % LATER MODULATION OF DISTORG AND DIST
            % s_dist is activated by id_dist
            m.mgen_production(:,s_dist_i) = 0.1 * id_dist_l.* inh (100, id_lat_l);          % Eqn 17  CHECKED

            % s_distorg is activated by id_distorg
            m.mgen_production(:,s_distorg_i) = 0.1 * id_distorg_l ;                         % Eqn 15 (but  CHECKED
            % note that distorg is set elsewhere) the 0.1 seems to be an error

            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                id_distorg_p = s_distorg_l;                                                 % Eqn 12  CHECKED
                id_distorg_l = id_distorg_p .* id_distorg_a;
                id_dist_p = s_dist_l;                                                       % Eqn 13  CHECKED (NOT NEEDED IN THIS MODEL)
                id_dist_l = id_dist_p .* id_dist_a;
            end
            % End Polariser
            %\latex \subsection{GRN (changes)}

            % id_rad is activated by id_cyc and id_dich at ALL TIMES
            id_rad_p = id_cyc_l +  0.3* id_dich_l;                                           % Eqn 1 % CHECKED
            id_rad_l = id_rad_p * id_rad_a;

            % s_rad is activated by id_rad
            m.mgen_production(:,s_rad_i) = 0.1 * id_rad_l .* pro (0.5, id_tube_l);          % Eqn 14 % CHECKED

            % I suspect that it is the order within this set of equations that matters because
            % cenorg depends on div and rim in the setup secton that also happen
            % at 240
            if abs(realtime - 240) <0.5*dt %At 240 hrs
                % continue with the initial regionalisation
                % replace [0,1] values with reals for quantitative growth

                %switch on id_div
                id_div_p=inh(100, id_rad_l);                           % Eqn 5 % CHECKED
                id_div_l=id_div_p.*id_div_a;

                %id_laterals is activated by id_div
                id_lts_p(:) = id_div_l;                                                      % Eqn 6 % CHECKED
                id_lts_l=id_lts_p * id_lts_a;
            end

            if abs(realtime - 250) <0.5*dt % At time 250 hrs
                %id_cyc and id_dich are inhibited by id_div in absence of id_rad.
                %This is to ensure that in a id_rad mutant,
                %id_cyc and id_dich are inactivated. (Also see constitutive cyc
                %below)
                id_cyc_p = id_cyc_l.* inh (4, id_div_l );                                    % Eqn 7 % CHECKED
                id_cyc_l = id_cyc_p * id_cyc_a;

                id_dich_p = id_dich_l .* inh (4, id_div_l );                                 % Eqn 8 % CHECKED
                id_dich_l = id_dich_p * id_dich_a;

                % one shot setup regionalising lateral petals
                id_lts_p=5*id_lts_l.* s_rad_l;                                               % Eqn 9 % CHECKED
                id_lts_l=id_lts_p.*id_lts_a;
            end
            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                % narrow domain of div expression with id_laterals and id_rad at ~ 14 days
                id_div_p = id_div_l .* inh (5, id_lts_l);                                   % Eqn 10
                id_div_l = id_div_p.*id_div_a;
            end

            % End Gene Networks

            %\latex \subsection{KRN (changes)}
            if realtime >= 250 && realtime<570  % Between time 250 570
                % Compute growth rates

                % Note: the factors are vectors, one element per vertex (node)
                % as a result, with each statement, different things happen in
                % different regions of the model.
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                Kpar=... % Eqn 260
                    0.013 ... % Background growth parallel to the polariser  Eqn 200
                    .* inh (0.2, id_prox_l)... %keeps base small                              Eqn 24 % CHECKED
                    .* pro (0.4,id_tube_l .* inh (100, id_plt_l))... %promote growth of tube  Eqn 25 % CHECKED
                    .* pro (1.4, id_early_p .* id_lip_l .*inh (100, id_rad_l.* inh(100, id_dich_l.* id_lat_l)))... %form lower face   Eqn 30 % CHECKED
                    .* inh (10,  id_early_p .* id_rim_l )... %inhibit rim to help with bending back    Eqn 32 % CHECKED
                    .* inh (0.5, id_late_p .* id_med_l.* id_lobe_l)... %reduce growth of midlobe   Eqn 38  % CHECKED
                    .* pro (2.4, id_early_p .* id_div_l.*id_plt_l )... %make lower tube arch over      Eqn 31 % CHECKED
                    ...
                    .* inh (1, id_rad_l .*id_lip_l .* inh(3, id_dich_l .* id_lat_l))... %prevent lip growing at edge of dorsals   Eqn 26 % CHECKED
                    .* inh (1, id_rad_l .*id_plt_l .* inh(10, id_dich_l) .* inh (20, id_cyc_l .* inh (40, id_lat_l.^2)))... %prevent palate growing at edge of dorsals   Eqn 27 % CHECKED
                    .* pro (0.3, id_cyc_l .* id_dtl_l  .* inh (0.5, id_dich_l))... %promote growth of lateral dorsal lobe         Eqn 28 % CHECKED
                    .* pro (0.45, (id_cyc_l + 0.2* id_dich_l) .* id_plt_l)... %promote medial palate growth with CYC              Eqn 29 % CHECKED
                    ;

                %AKapar=0.06* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % bend back petals   Eqn 36 % CHECKED

                % Background growth normal to the polariser   Eqn 201

                Kper=... % Eqn 250
                    0.0075 ... % Background growth normal to the polariser   Eqn 201
                    .* inh (0.2, id_prox_l)... %keep base small   Eqn 43   % CHECKED
                    .* pro(2, id_early_p .* id_dist_l .* inh (20, id_lat_l))... %  widen distal lobe    Eqn 46  % CHECKED
                    .* inh (0.3, id_late_p .* id_lobe_l .* id_med_l)... %keep medial lobe narrow   Eqn 50  % CHECKED
                    .* pro (1,   id_late_p .* id_dist_l .* pro (1.2, (id_cyc_l + id_div_l)))... % increase width of distal lobe   Eqn 49  % CHECKED
                    .* inh (1, id_late_p .* id_div_l .* inh(10, id_lobe_l))... .* inh (2,id_lpb_l)).* pro(1, id_plt_l))...  %narrow ventral petals    Eqn 51  % CHECKED USED LOBE NOT DTL
                    ...
                    .* pro (0.1, id_cyc_l  .* pro(1.5,id_lip_l))... % increase width of dorsal petal    Eqn 44  % CHECKED
                    .* inh(6, id_early_p .* id_lts_l.*id_med_l )... %  keep laterals narrow initially   Eqn 45
                    .* pro (0.2, id_late_p .* id_lts_l .* id_med_l .*  id_plt_l); %promote growth of lateral width   Eqn 52   ADDD Fig 6G Model 3

                % compute the growth rates
                kapar=Kpar ...% Eqn 300
                    + 0.06* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % Eqn 301
                kbpar=Kpar ;% Eqn 310
                kaper=Kper ;% Eqn 320
                kbper=Kper ;% Eqn 330
                knor =0.003; % thickness tracks model using Scaled USE KNOR(anti-curl) Eqn 305
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif strcmpi(modelnumber,'Fig 7B Model 4')
            % P EQUATIONS
            % START POLARISER section (it is slightly mixed with gene networks)
            m = leaf_mgen_conductivity( m, 's_distorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_distorg', 0.05);  % it will not decay everywhere
            m.globalProps.mingradient=0.01; % this ensures that all polariser gradients are frozen
            m = leaf_mgen_conductivity( m, 'Polariser', 0.002);% diffusion constant WAS 0.001
            m = leaf_mgen_dilution( m, 'Polariser', false );% it will not dilute with growth
            m = leaf_mgen_absorption( m, 'Polariser', 0.1);  % it will not decay everywhere

            %\latex \subsection{PRN (changes)}
            % POLARISER PRODUCTION
            if realtime>230 % From time 230  generate polariser
                id_proxorg_p = (id_prox_l >0.8);                                             % Eqn 2  CHECKED
                id_proxorg_l = id_proxorg_p * id_proxorg_a;
            end

            % POLARISER DECAY
            % switch on distorg with id_dist in the absence of id_lat
            if abs(realtime - 230) <0.5*dt % At time 230 hrs
                id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l);%  CHECKED % Eqn 3 (used in production equation)
                id_distorg_l = id_distorg_p * id_distorg_a;
                m.userdata.all_regions_ready=true;
            end

            m.mgen_production(:,polariser_i) = 0.1 * (id_proxorg_l + 1 - P .* id_distorg_l);  % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE

            % LATER MODULATION OF DISTORG AND DIST
            % s_dist is activated by id_dist
            m.mgen_production(:,s_dist_i) = 0.1 * id_dist_l.* inh (100, id_lat_l);          % Eqn 17  CHECKED

            % s_distorg is activated by id_distorg
            m.mgen_production(:,s_distorg_i) = 0.1 * id_distorg_l ;                         % Eqn 15 (but  CHECKED
            % note that distorg is set elsewhere) the 0.1 seems to be an error

            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                id_distorg_p = s_distorg_l;                                                 % Eqn 12  CHECKED
                id_distorg_l = id_distorg_p .* id_distorg_a;
                id_dist_p = s_dist_l;                                                       % Eqn 13  CHECKED (NOT NEEDED IN THIS MODEL)
                id_dist_l = id_dist_p .* id_dist_a;
            end
            % End Polariser
            %\latex \subsection{GRN (changes)}

            % id_rad is activated by id_cyc and id_dich at ALL TIMES
            id_rad_p = id_cyc_l +  0.3* id_dich_l;                                           % Eqn 1 % CHECKED
            id_rad_l = id_rad_p * id_rad_a;

            % s_rad is activated by id_rad
            m.mgen_production(:,s_rad_i) = 0.1 * id_rad_l .* pro (0.5, id_tube_l);          % Eqn 14 % CHECKED

            % I suspect that it is the order within this set of equations that matters because
            % cenorg depends on div and rim in the setup secton that also happen
            % at 240
            if abs(realtime - 240) <0.5*dt %At 240 hrs
                % continue with the initial regionalisation
                % replace [0,1] values with reals for quantitative growth

                %switch on id_div
                id_div_p=inh(100, id_rad_l);                           % Eqn 5 % CHECKED
                id_div_l=id_div_p.*id_div_a;

                %id_laterals is activated by id_div
                id_lts_p(:) = id_div_l;                                                      % Eqn 6 % CHECKED
                id_lts_l=id_lts_p * id_lts_a;
            end

            if abs(realtime - 250) <0.5*dt % At time 250 hrs
                %id_cyc and id_dich are inhibited by id_div in absence of id_rad.
                %This is to ensure that in a id_rad mutant,
                %id_cyc and id_dich are inactivated. (Also see constitutive cyc
                %below)
                id_cyc_p = id_cyc_l.* inh (4, id_div_l );                                    % Eqn 7 % CHECKED
                id_cyc_l = id_cyc_p * id_cyc_a;

                id_dich_p = id_dich_l .* inh (4, id_div_l );                                 % Eqn 8 % CHECKED
                id_dich_l = id_dich_p * id_dich_a;

                % one shot setup regionalising lateral petals
                id_lts_p=5*id_lts_l.* s_rad_l;                                               % Eqn 9 % CHECKED
                id_lts_l=id_lts_p.*id_lts_a;
            end
            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                % narrow domain of div expression with id_laterals and id_rad at ~ 14 days
                id_div_p = id_div_l .* inh (5, id_lts_l);                                   % Eqn 10
                id_div_l = id_div_p.*id_div_a;
            end

            % End Gene Networks

            %\latex \subsection{KRN (changes)}
            if realtime >= 250 && realtime<570  % Between time 250 570
                % Compute growth rates

                % Note: the factors are vectors, one element per vertex (node)
                % as a result, with each statement, different things happen in
                % different regions of the model.
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                Kpar=... % Eqn 260
                    0.013 ... % Background growth parallel to the polariser  Eqn 200
                    .* inh (0.2, id_prox_l)... %keeps base small                              Eqn 24 % CHECKED
                    .* pro (0.4,id_tube_l .* inh (100, id_plt_l))... %promote growth of tube  Eqn 25 % CHECKED
                    .* pro (1.4, id_early_p .* id_lip_l .*inh (100, id_rad_l.* inh(100, id_dich_l.* id_lat_l)))... %form lower face   Eqn 30 % CHECKED
                    .* inh (10,  id_early_p .* id_rim_l )... %inhibit rim to help with bending back    Eqn 32 % CHECKED
                    .* inh (0.5, id_late_p .* id_med_l.* id_lobe_l)... %reduce growth of midlobe   Eqn 38  % CHECKED
                    .* pro (2.4, id_early_p .* id_div_l.*id_plt_l )... %make lower tube arch over      Eqn 31 % CHECKED
                    .* inh (1, id_rad_l .*id_lip_l .* inh(3, id_dich_l .* id_lat_l))... %prevent lip growing at edge of dorsals   Eqn 26 % CHECKED
                    .* inh (1, id_rad_l .*id_plt_l .* inh(10, id_dich_l) .* inh (20, id_cyc_l .* inh (40, id_lat_l.^2)))... %prevent palate growing at edge of dorsals   Eqn 27 % CHECKED
                    .* pro (0.3, id_cyc_l .* id_dtl_l  .* inh (0.5, id_dich_l))... %promote growth of lateral dorsal lobe         Eqn 28 % CHECKED
                    .* pro (0.45, (id_cyc_l + 0.2* id_dich_l) .* id_plt_l)... %promote medial palate growth with CYC              Eqn 29 % CHECKED
                    ;

                %AKapar=0.06* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % bend back petals   Eqn 36 % CHECKED

                % Background growth normal to the polariser   Eqn 201

                Kper=... % Eqn 250
                    0.0075 ... % Background growth normal to the polariser   Eqn 201
                    .* inh (0.2, id_prox_l)... %keep base small   Eqn 43   % CHECKED
                    .* pro(2, id_early_p .* id_dist_l .* inh (20, id_lat_l))... %  widen distal lobe    Eqn 46  % CHECKED
                    .* inh (0.3, id_late_p .* id_lobe_l .* id_med_l)... %keep medial lobe narrow   Eqn 50  % CHECKED
                    .* pro (1,   id_late_p .* id_dist_l .* pro (1.2, (id_cyc_l + id_div_l)))... % increase width of distal lobe   Eqn 49  % CHECKED
                    .* inh (1, id_late_p .* id_div_l .* inh(10, id_lobe_l))... .* inh (2,id_lpb_l)).* pro(1, id_plt_l))...  %narrow ventral petals    Eqn 51  % CHECKED USED LOBE NOT DTL
                    .* pro (0.1, id_cyc_l  .* pro(1.5,id_lip_l))... % increase width of dorsal petal    Eqn 44  % CHECKED
                    .* inh(6, id_early_p .* id_lts_l.*id_med_l )... %  keep laterals narrow initially   Eqn 45
                    .* pro (0.2, id_late_p .* id_lts_l .* id_med_l .*  id_plt_l)... %promote growth of lateral width   Eqn 52   ADDD Fig 6G Model 3
                    ...
                    .* pro (3.5, id_late_p.*id_lts_l .* id_med_l .* inh(4, id_lat_l) .*pro(1,(id_lip_l + 0.3* id_plt_l)))...%  Fig 6G Model 3M1 promote lateral growth (from par)
                    ;
                % compute the growth rates
                kapar=Kpar ...% Eqn 300
                    +0.06* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % Eqn 301
                kbpar=Kpar ;% Eqn 310
                kaper=Kper ;% Eqn 320
                kbper=Kper ;% Eqn 330
                knor =0.003; % thickness tracks model using Scaled USE KNOR(anti-curl) Eqn 305
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif strcmpi(modelnumber,'Fig 7I Model 5')
            % P EQUATIONS
            % START POLARISER section (it is slightly mixed with gene networks)
            m = leaf_mgen_conductivity( m, 's_distorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_distorg', 0.05);  % it will not decay everywhere
            m.globalProps.mingradient=0.01; % this ensures that all polariser gradients are frozen
            m = leaf_mgen_conductivity( m, 'Polariser', 0.002);% diffusion constant WAS 0.001
            m = leaf_mgen_dilution( m, 'Polariser', false );% it will not dilute with growth
            m = leaf_mgen_absorption( m, 'Polariser', 0.1);  % it will not decay everywhere

            m = leaf_mgen_conductivity( m, 's_cenorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_cenorg', 0.05);  % it will not decay everywhere

            %\latex \subsection{PRN (changes)}
            % POLARISER PRODUCTION
            if realtime>230 % From time 230  generate polariser
                id_proxorg_p = (id_prox_l >0.8);                                             % Eqn 2  CHECKED
                id_proxorg_l = id_proxorg_p * id_proxorg_a;
            end

            % POLARISER DECAY
            % switch on distorg with id_dist in the absence of id_lat
            if abs(realtime - 230) <0.5*dt % At time 230 hrs
                id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l);%  CHECKED % Eqn 3 (used in production equation)
                id_distorg_l = id_distorg_p * id_distorg_a;
                m.userdata.all_regions_ready=true;
            end
            if abs(realtime - 245) <0.5*dt %At 240 hrs
                %id_cenorg is activated by id_rim, id_lat and
                % id_div in absence of id_rad
                id_cenorg_p = 0.6*id_lat_l .* id_rim_l .* id_div_l ;                                   % Eqn 4 % CHECKED
                id_cenorg_l = id_cenorg_p * id_cenorg_a;
            end

            %m.mgen_production(:,polariser_i) = m.mgen_production(:,polariser_i) - 0.1 * P .* (id_distorg_l+3*id_late_p.*id_cenorg_l);                                           % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE
            m.mgen_production(:,polariser_i) = 0.1 * (id_proxorg_l + 1 - P .* (id_distorg_l+3*id_late_p.*id_cenorg_l));  % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE

            % LATER MODULATION OF DISTORG AND DIST
            % s_dist is activated by id_dist
            m.mgen_production(:,s_dist_i) = 0.1 * id_dist_l.* inh (100, id_lat_l);          % Eqn 17  CHECKED

            % s_distorg is activated by id_distorg
            m.mgen_production(:,s_distorg_i) = 0.1 * id_distorg_l ;                         % Eqn 15 (but  CHECKED
            % note that distorg is set elsewhere) the 0.1 seems to be an error

            % s_cenorg is activated by id_cenorg
            m.mgen_production(:,s_cenorg_i) = 0.1 * id_cenorg_l;                             % Eqn 16 % CHECKED

            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                id_cenorg_p = s_cenorg_l;                                                   % Eqn 11 % CHECKED
                id_cenorg_l = id_cenorg_p .* id_cenorg_a;
                id_distorg_p = s_distorg_l;                                                 % Eqn 12  CHECKED
                id_distorg_l = id_distorg_p .* id_distorg_a;
                id_dist_p = s_dist_l;                                                       % Eqn 13  CHECKED (NOT NEEDED IN THIS MODEL)
                id_dist_l = id_dist_p .* id_dist_a;
            end
            % End Polariser
            %\latex \subsection{GRN (changes)}

            % id_rad is activated by id_cyc and id_dich at ALL TIMES
            id_rad_p = id_cyc_l +  0.3* id_dich_l;                                           % Eqn 1 % CHECKED
            id_rad_l = id_rad_p * id_rad_a;

            % s_rad is activated by id_rad
            m.mgen_production(:,s_rad_i) = 0.1 * id_rad_l .* pro (0.5, id_tube_l);          % Eqn 14 % CHECKED

            % I suspect that it is the order within this set of equations that matters because
            % cenorg depends on div and rim in the setup secton that also happen
            % at 240
            if abs(realtime - 240) <0.5*dt % At time 240 hrs
                % continue with the initial regionalisation
                % replace [0,1] values with reals for quantitative growth

                %switch on id_div
                id_div_p=inh(100, id_rad_l);                           % Eqn 5 % CHECKED
                id_div_l=id_div_p.*id_div_a;

                %id_laterals is activated by id_div
                id_lts_p(:) = id_div_l;                                                      % Eqn 6 % CHECKED
                id_lts_l=id_lts_p * id_lts_a;
            end

            if abs(realtime - 250) <0.5*dt % At time 250 hrs
                %id_cyc and id_dich are inhibited by id_div in absence of id_rad.
                %This is to ensure that in a id_rad mutant,
                %id_cyc and id_dich are inactivated. (Also see constitutive cyc
                %below)
                id_cyc_p = id_cyc_l.* inh (4, id_div_l );                                    % Eqn 7 % CHECKED
                id_cyc_l = id_cyc_p * id_cyc_a;

                id_dich_p = id_dich_l .* inh (4, id_div_l );                                 % Eqn 8 % CHECKED
                id_dich_l = id_dich_p * id_dich_a;

                % one shot setup regionalising lateral petals
                id_lts_p=5*id_lts_l.* s_rad_l;                                               % Eqn 9 % CHECKED
                id_lts_l=id_lts_p.*id_lts_a;
            end
            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                % narrow domain of div expression with id_laterals and id_rad at ~ 14 days
                id_div_p = id_div_l .* inh (5, id_lts_l);                                   % Eqn 10
                id_div_l = id_div_p.*id_div_a;
            end

            % End Gene Networks

            %\latex \subsection{KRN (changes)}
            if realtime >= 250 && realtime<570  % Between time 250 570
                % Compute growth rates

                % Note: the factors are vectors, one element per vertex (node)
                % as a result, with each statement, different things happen in
                % different regions of the model.
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                Kpar=... % Eqn 260
                    0.013 ... % Background growth parallel to the polariser  Eqn 200
                    .* inh (0.2, id_prox_l)... %keeps base small                              Eqn 24 % CHECKED
                    .* pro (0.4,id_tube_l .* inh (100, id_plt_l))... %promote growth of tube  Eqn 25 % CHECKED
                    .* pro (1.4, id_early_p .* id_lip_l .*inh (100, id_rad_l.* inh(100, id_dich_l.* id_lat_l)))... %form lower face   Eqn 30 % CHECKED
                    .* inh (10,  id_early_p .* id_rim_l )... %inhibit rim to help with bending back    Eqn 32 % CHECKED
                    .* inh (0.5, id_late_p .* id_med_l.* id_lobe_l)... %reduce growth of midlobe   Eqn 38  % CHECKED
                    .* pro (2.4, id_early_p .* id_div_l.*id_plt_l )... %make lower tube arch over      Eqn 31 % CHECKED
                    .* inh (1, id_rad_l .*id_lip_l .* inh(3, id_dich_l .* id_lat_l))... %prevent lip growing at edge of dorsals   Eqn 26 % CHECKED
                    .* inh (1, id_rad_l .*id_plt_l .* inh(10, id_dich_l) .* inh (20, id_cyc_l .* inh (40, id_lat_l.^2)))... %prevent palate growing at edge of dorsals   Eqn 27 % CHECKED
                    .* pro (0.3, id_cyc_l .* id_dtl_l  .* inh (0.5, id_dich_l))... %promote growth of lateral dorsal lobe         Eqn 28 % CHECKED
                    .* pro (0.45, (id_cyc_l + 0.2* id_dich_l) .* id_plt_l)... %promote medial palate growth with CYC              Eqn 29 % CHECKED
                    ...
                    .* pro (2.2, id_late_p .* id_lts_l .* id_med_l .* inh (0.5, id_lpb_l).* inh(4, id_lat_l) .*(id_lip_l + 0.3* id_plt_l));%  promote lateral growth   Eqn 42 % CHECKED


                %AKapar=0.05* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % bend back petals   Eqn 36 % CHECKED

                % Background growth normal to the polariser   Eqn 201

                Kper=... % Eqn 250
                    0.0075 ... % Background growth normal to the polariser   Eqn 201
                    .* inh (0.2, id_prox_l)... %keep base small   Eqn 43   % CHECKED
                    .* pro(2, id_early_p .* id_dist_l .* inh (20, id_lat_l))... %  widen distal lobe    Eqn 46  % CHECKED
                    .* inh (0.3, id_late_p .* id_lobe_l .* id_med_l)... %keep medial lobe narrow   Eqn 50  % CHECKED
                    .* pro (1,   id_late_p .* id_dist_l .* pro (1.2, (id_cyc_l + id_div_l)))... % increase width of distal lobe   Eqn 49  % CHECKED
                    .* inh (1, id_late_p .* id_div_l .* inh(10, id_lobe_l))... .* inh (2,id_lpb_l)).* pro(1, id_plt_l))...  %narrow ventral petals    Eqn 51  % CHECKED USED LOBE NOT DTL
                    .* pro (0.1, id_cyc_l  .* pro(1.5,id_lip_l))... % increase width of dorsal petal    Eqn 44  % CHECKED
                    .* inh(6, id_early_p .* id_lts_l.*id_med_l )... %  keep laterals narrow initially   Eqn 45
                    .* pro (0.2, id_late_p .* id_lts_l .* id_med_l .*  id_plt_l); %promote growth of lateral width   Eqn 52   ADDD Fig 6G Model 3

                % compute the growth rates
                kapar=Kpar ...% Eqn 300
                    +0.05* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % Eqn 301
                kbpar=Kpar ;% Eqn 310
                kaper=Kper ;% Eqn 320
                kbper=Kper ;% Eqn 330
                knor =0.003; % thickness tracks model using Scaled USE KNOR(anti-curl) Eqn 305
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif strcmpi(modelnumber,'Fig 8C Model 6') %
            % P EQUATIONS
            % START POLARISER section (it is slightly mixed with gene networks)
            m = leaf_mgen_conductivity( m, 's_distorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_distorg', 0.05);  % it will not decay everywhere
            m.globalProps.mingradient=0.01; % this ensures that all polariser gradients are frozen
            m = leaf_mgen_conductivity( m, 'Polariser', 0.002);% diffusion constant WAS 0.001
            m = leaf_mgen_dilution( m, 'Polariser', false );% it will not dilute with growth
            m = leaf_mgen_absorption( m, 'Polariser', 0.1);  % it will not decay everywhere

            m = leaf_mgen_conductivity( m, 's_cenorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_cenorg', 0.05);  % it will not decay everywhere

            %\latex \subsection{PRN (changes)}
            % POLARISER PRODUCTION
            if realtime>230 % From time 230  generate polariser
                id_proxorg_p = (id_prox_l >0.8);                                             % Eqn 2  CHECKED
                id_proxorg_l = id_proxorg_p * id_proxorg_a;
            end

            % POLARISER DECAY
            % switch on distorg with id_dist in the absence of id_lat
            if abs(realtime - 230) <0.5*dt % At time 230 hrs
                id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l);%  CHECKED % Eqn 3 (used in production equation)
                id_distorg_l = id_distorg_p * id_distorg_a;
                m.userdata.all_regions_ready=true;
%                 id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l)...                       % CHECKED
%                     + 0.1*(v_dichdistorg_p.*id_dich_l) .* id_dist_l .* id_cyc_l;           % Eqn 3 (used in production equation)
%                 id_distorg_l = id_distorg_p * id_distorg_a;
%                 m.userdata.all_regions_ready=true;
%                 v_dichdistorg_p=v_dichdistorg_p.*id_dich_l.* id_dist_l .* id_cyc_l;
            end
            
            if abs(realtime - 245) <0.5*dt %At 240 hrs
                %id_cenorg is activated by id_rim, id_lat and
                % id_div in absence of id_rad
                id_cenorg_p = 0.6*id_lat_l .* id_rim_l .* id_div_l ;                                   % Eqn 4 % CHECKED
                id_cenorg_l = id_cenorg_p * id_cenorg_a;
            end

            m.mgen_production(:,polariser_i) = 0.1 * (id_proxorg_l + 1 - P .* (id_distorg_l+3*id_late_p.*id_cenorg_l));  % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE

            % LATER MODULATION OF DISTORG AND DIST
            % s_dist is activated by id_dist
            m.mgen_production(:,s_dist_i) = 0.1 * id_dist_l.* inh (100, id_lat_l);          % Eqn 17  CHECKED

            % s_distorg is activated by id_distorg
            m.mgen_production(:,s_distorg_i) = 0.1 * id_distorg_l ;                         % Eqn 15 (but  CHECKED

            % s_cenorg is activated by id_cenorg
            m.mgen_production(:,s_cenorg_i) = 0.1 * id_cenorg_l;                             % Eqn 16 % CHECKED

            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                id_cenorg_p = s_cenorg_l;                                                   % Eqn 11 % CHECKED
                id_cenorg_l = id_cenorg_p .* id_cenorg_a;
                id_distorg_p = s_distorg_l;                                                 % Eqn 12  CHECKED
                id_distorg_l = id_distorg_p .* id_distorg_a;
                id_dist_p = s_dist_l;                                                       % Eqn 13  CHECKED (NOT NEEDED IN THIS MODEL)
                id_dist_l = id_dist_p .* id_dist_a;
            end
            % End Polariser
            %\latex \subsection{GRN (changes)}

            % id_rad is activated by id_cyc and id_dich at ALL TIMES
            id_rad_p = id_cyc_l +  0.3* id_dich_l;                                           % Eqn 1 % CHECKED
            id_rad_l = id_rad_p * id_rad_a;

            % s_rad is activated by id_rad
            m.mgen_production(:,s_rad_i) = 0.1 * id_rad_l .* pro (0.5, id_tube_l);          % Eqn 14 % CHECKED

            % I suspect that it is the order within this set of equations that matters because
            % cenorg depends on div and rim in the setup secton that also happen
            % at 240
            if abs(realtime - 240) <0.5*dt %At 240 hrs
                % continue with the initial regionalisation
                % replace [0,1] values with reals for quantitative growth

                %switch on id_div
                id_div_p=inh(100, id_rad_l);                           % Eqn 5 % CHECKED
                id_div_l=id_div_p.*id_div_a;

                %id_laterals is activated by id_div
                id_lts_p(:) = id_div_l;                                                      % Eqn 6 % CHECKED
                id_lts_l=id_lts_p * id_lts_a;
            end

            if abs(realtime - 250) <0.5*dt % At time 250 hrs
                %id_cyc and id_dich are inhibited by id_div in absence of id_rad.
                %This is to ensure that in a id_rad mutant,
                %id_cyc and id_dich are inactivated. (Also see constitutive cyc
                %below)
                id_cyc_p = id_cyc_l.* inh (4, id_div_l );                                    % Eqn 7 % CHECKED
                id_cyc_l = id_cyc_p * id_cyc_a;

                id_dich_p = id_dich_l .* inh (4, id_div_l );                                 % Eqn 8 % CHECKED
                id_dich_l = id_dich_p * id_dich_a;

                % one shot setup regionalising lateral petals
                id_lts_p=5*id_lts_l.* s_rad_l;                                               % Eqn 9 % CHECKED
                id_lts_l=id_lts_p.*id_lts_a;
            end
            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                % narrow domain of div expression with id_laterals and id_rad at ~ 14 days
                id_div_p = id_div_l .* inh (5, id_lts_l);                                   % Eqn 10
                id_div_l = id_div_p.*id_div_a;
            end

            % End Gene Networks

            %\latex \subsection{KRN (changes)}
            if realtime >= 250 && realtime<570  % Between time 250 570
                % Compute growth rates

                % Note: the factors are vectors, one element per vertex (node)
                % as a result, with each statement, different things happen in
                % different regions of the model.
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                Kpar=... % Eqn 260
                    0.013 ... % Background growth parallel to the polariser  Eqn 200
                    .* inh (0.2, id_prox_l)... %keeps base small                              Eqn 24 % CHECKED
                    .* pro (0.4,id_tube_l .* inh (100, id_plt_l))... %promote growth of tube  Eqn 25 % CHECKED
                    .* pro (1.4, id_early_p .* id_lip_l .*inh (100, id_rad_l.* inh(100, id_dich_l.* id_lat_l)))... %form lower face   Eqn 30 % CHECKED
                    .* inh (10,  id_early_p .* id_rim_l )... %inhibit rim to help with bending back    Eqn 32 % CHECKED
                    .* inh (0.5, id_late_p .* id_med_l.* id_lobe_l)... %reduce growth of midlobe   Eqn 38  % CHECKED
                    .* pro (2.4, id_early_p .* id_div_l.*id_plt_l )... %make lower tube arch over      Eqn 31 % CHECKED
                    .* inh (1, id_rad_l .*id_lip_l .* inh(3, id_dich_l .* id_lat_l))... %prevent lip growing at edge of dorsals   Eqn 26 % CHECKED
                    .* inh (1, id_rad_l .*id_plt_l .* inh(10, id_dich_l) .* inh (20, id_cyc_l .* inh (40, id_lat_l.^2)))... %prevent palate growing at edge of dorsals   Eqn 27 % CHECKED
                    .* pro (0.3, id_cyc_l .* id_dtl_l  .* inh (0.5, id_dich_l))... %promote growth of lateral dorsal lobe         Eqn 28 % CHECKED
                    .* pro (0.45, (id_cyc_l + 0.2* id_dich_l) .* id_plt_l)... %promote medial palate growth with CYC              Eqn 29 % CHECKED
                    .* pro (2.2, id_late_p .* id_lts_l .* id_med_l .* inh (0.5, id_lpb_l).* inh(4, id_lat_l) .*(id_lip_l + 0.3* id_plt_l))...%  promote lateral growth   Eqn 42 % CHECKED
                    ... %%%%%%% FINE TUNING %%%%%% better formed palate
                    .* inh (10,  id_late_p .* id_div_l .*id_cenorg_l.* inh(2, id_lpb_l).* pro (10, id_plt_l .* id_med_l))...% prevent lips protruding   Eqn 39
                    .* pro (0.2, id_late_p .* id_div_l .* id_plt_l)... %promote growth of palate   Eqn 40
                    .* inh (0.7, id_late_p .* id_lts_l .* id_lat_l .* (id_lip_l + id_plt_l)); %inhibit growth at edge of laterals   Eqn 41



%                 DKapar=1 ... %%%%%%% FINE TUNING %%%%%%
%                     .* inh (1, id_dich_l.* id_lat_l  .* id_lpb_l)...                               % Eqn 33
%                     .* inh (1, id_early_p .* (id_cyc_l + id_div_l) .*id_mlobe_l .* inh (5, id_dich_l))... %bend up distal lobes   Eqn 34
%                     .* pro (1, id_early_p .*  id_div_l .* id_lpb_l.* inh (5, id_med_l))... % bend out lips   Eqn 35

                %AKapar=0.05* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % bend back petals   Eqn 36 % CHECKED
                 
                %%%%%%% FINE TUNING %%%%%%
                %DKbpar=pro (2, id_dich_l .* id_lat_l  .* id_lpb_l); % bend dorsal lip forward   Eqn 37  % CHECKED 

                % Background growth normal to the polariser   Eqn 201

                Kper=... % Eqn 250
                    0.0075 ... % Background growth normal to the polariser   Eqn 201
                    .* inh (0.2, id_prox_l)... %keep base small   Eqn 43   % CHECKED
                    .* pro(2, id_early_p .* id_dist_l .* inh (20, id_lat_l))... %  widen distal lobe    Eqn 46  % CHECKED
                    .* inh (0.3, id_late_p .* id_lobe_l .* id_med_l)... %keep medial lobe narrow   Eqn 50  % CHECKED
                    .* pro (1,   id_late_p .* id_dist_l .* pro (1.2, (id_cyc_l + id_div_l)))... % increase width of distal lobe   Eqn 49  % CHECKED
                    .* inh (1.3, id_late_p .* id_div_l .* inh(2.5, id_lobe_l.* inh (2,id_lpb_l)).* pro(1, id_plt_l))...  %narrow ventral petals    Eqn 51 %%%%%%% FINE TUNING %%%%%%
                    .* pro (0.1, id_cyc_l  .* pro(1.5,id_lip_l))... % increase width of dorsal petal    Eqn 44  % CHECKED
                    .* inh(6, id_early_p .* id_lts_l.*id_med_l )... %  keep laterals narrow initially   Eqn 45
                    .* pro (0.2, id_late_p .* id_lts_l .* id_med_l .*  id_plt_l); %promote growth of lateral width   Eqn 52   ADDD Fig 6G Model 3

                %%%%%%% FINE TUNING %%%%%%
%                 DKaper = pro (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 47
%                 DKbper = inh (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 48


                % compute the growth rates
                kapar=Kpar ...% Eqn 300
                    .* inh (1, id_dich_l.* id_lat_l  .* id_lpb_l)...                               % Eqn 33
                    .* inh (1, id_early_p .* (id_cyc_l + id_div_l) .*id_mlobe_l .* inh (5, id_dich_l))... %bend up distal lobes   Eqn 34
                    .* pro (1, id_early_p .*  id_div_l .* id_lpb_l.* inh (5, id_med_l))... % bend out lips   Eqn 35
                    +0.05* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % Eqn 301
                kbpar=Kpar ... % Eqn 310
                    .*pro (2, id_dich_l .* id_lat_l  .* id_lpb_l); % Eqn 37
                kaper=Kper ... % Eqn 320
                    .* pro (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 47
                kbper=Kper ... % Eqn 330
                    .*inh (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 48 
                knor =0.003; % thickness tracks model using Scaled USE KNOR(anti-curl) Eqn 305
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif strcmpi(modelnumber,'Fig 9B Model 7') || strcmpi(modelnumber,'Fig 9B Model 7M2') || strcmpi(modelnumber,'Fig 9B Model 7M3') 
            % P EQUATIONS
            % START POLARISER section (it is slightly mixed with gene networks)
            m = leaf_mgen_conductivity( m, 's_distorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_distorg', 0.05);  % it will not decay everywhere
            m.globalProps.mingradient=0.01; % this ensures that all polariser gradients are frozen
            m = leaf_mgen_conductivity( m, 'Polariser', 0.002);% diffusion constant WAS 0.001
            m = leaf_mgen_dilution( m, 'Polariser', false );% it will not dilute with growth
            m = leaf_mgen_absorption( m, 'Polariser', 0.1);  % it will not decay everywhere

            m = leaf_mgen_conductivity( m, 's_cenorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_cenorg', 0.05);  % it will not decay everywhere

            %\latex \subsection{PRN (changes)}
            % POLARISER PRODUCTION
            if realtime>230 % From time 230  generate polariser
                id_proxorg_p = (id_prox_l >0.8);                                             % Eqn 2  CHECKED
                id_proxorg_l = id_proxorg_p * id_proxorg_a;
            end

            % POLARISER DECAY
            % switch on distorg with id_dist in the absence of id_lat
            if abs(realtime - 230) <0.5*dt % At time 230 hrs
%                 id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l);%  CHECKED % Eqn 3 (used in production equation)
%                 id_distorg_l = id_distorg_p * id_distorg_a;
%                 m.userdata.all_regions_ready=true;
                id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l)+ 0.1*id_dich_l .* id_dist_l .* id_cyc_l;           % Eqn 3 (used in production equation)
                id_distorg_l = id_distorg_p * id_distorg_a;
                m.userdata.all_regions_ready=true;
                v_dichdistorg_p=v_dichdistorg_p.*id_dich_l.* id_dist_l .* id_cyc_l;
            end
            
            if abs(realtime - 245) <0.5*dt %At 240 hrs
                %id_cenorg is activated by id_rim, id_lat and
                % id_div in absence of id_rad
                id_cenorg_p = 0.6*id_lat_l .* id_rim_l .* id_div_l ;                                   % Eqn 4 % CHECKED
                id_cenorg_l = id_cenorg_p * id_cenorg_a;
            end

            m.mgen_production(:,polariser_i) = 0.1 * (id_proxorg_l + 1 - P .* (id_distorg_l+3*id_late_p.*id_cenorg_l)); % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE
            %m.mgen_production(:,polariser_i) = m.mgen_production(:,polariser_i) - 0.1 * P .* (id_distorg_l+3*id_late_p.*id_cenorg_l);  % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE

            % LATER MODULATION OF DISTORG AND DIST
            % s_dist is activated by id_dist
            m.mgen_production(:,s_dist_i) = 0.1 * id_dist_l.* inh (100, id_lat_l);          % Eqn 17  CHECKED

            % s_distorg is activated by id_distorg
            m.mgen_production(:,s_distorg_i) = 0.1 * id_distorg_l ;                         % Eqn 15 (but  CHECKED

            % s_cenorg is activated by id_cenorg
            m.mgen_production(:,s_cenorg_i) = 0.1 * id_cenorg_l;                             % Eqn 16 % CHECKED

            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                id_cenorg_p = s_cenorg_l;                                                   % Eqn 11 % CHECKED
                id_cenorg_l = id_cenorg_p .* id_cenorg_a;
                id_distorg_p = s_distorg_l;                                                 % Eqn 12  CHECKED
                id_distorg_l = id_distorg_p .* id_distorg_a;
                id_dist_p = s_dist_l;                                                       % Eqn 13  CHECKED (NOT NEEDED IN THIS MODEL)
                id_dist_l = id_dist_p .* id_dist_a;
            end
            % End Polariser
            %\latex \subsection{GRN (changes)}

            % id_rad is activated by id_cyc and id_dich at ALL TIMES
            id_rad_p = id_cyc_l +  0.3* id_dich_l;                                           % Eqn 1 % CHECKED
            id_rad_l = id_rad_p * id_rad_a;

            % s_rad is activated by id_rad
            m.mgen_production(:,s_rad_i) = 0.1 * id_rad_l .* pro (0.5, id_tube_l);          % Eqn 14 % CHECKED

            % I suspect that it is the order within this set of equations that matters because
            % cenorg depends on div and rim in the setup secton that also happen
            % at 240
            if abs(realtime - 240) <0.5*dt %At 240 hrs
                % continue with the initial regionalisation
                % replace [0,1] values with reals for quantitative growth

                %switch on id_div
                id_div_p=inh(100, id_rad_l);                           % Eqn 5 % CHECKED
                id_div_l=id_div_p.*id_div_a;

                %id_laterals is activated by id_div
                id_lts_p(:) = id_div_l;                                                      % Eqn 6 % CHECKED
                id_lts_l=id_lts_p * id_lts_a;
            end

            if abs(realtime - 250) <0.5*dt % At time 250 hrs
                %id_cyc and id_dich are inhibited by id_div in absence of id_rad.
                %This is to ensure that in a id_rad mutant,
                %id_cyc and id_dich are inactivated. (Also see constitutive cyc
                %below)
                id_cyc_p = id_cyc_l.* inh (4, id_div_l );                                    % Eqn 7 % CHECKED
                id_cyc_l = id_cyc_p * id_cyc_a;

                id_dich_p = id_dich_l .* inh (4, id_div_l );                                 % Eqn 8 % CHECKED
                id_dich_l = id_dich_p * id_dich_a;

                % one shot setup regionalising lateral petals
                id_lts_p=5*id_lts_l.* s_rad_l;                                               % Eqn 9 % CHECKED
                id_lts_l=id_lts_p.*id_lts_a;
            end
            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                % narrow domain of div expression with id_laterals and id_rad at ~ 14 days
                id_div_p = id_div_l .* inh (5, id_lts_l);                                   % Eqn 10
                id_div_l = id_div_p.*id_div_a;
            end

            % End Gene Networks

            %\latex \subsection{KRN (changes)}
            if realtime >= 250 && realtime<570  % Between time 250 570
                % Compute growth rates

                % Note: the factors are vectors, one element per vertex (node)
                % as a result, with each statement, different things happen in
                % different regions of the model.
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                Kpar=... % Eqn 260
                    0.013 ... % Background growth parallel to the polariser  Eqn 200
                    .* inh (0.2, id_prox_l)... %keeps base small                              Eqn 24 % CHECKED
                    .* pro (0.4,id_tube_l .* inh (100, id_plt_l))... %promote growth of tube  Eqn 25 % CHECKED
                    .* pro (1.4, id_early_p .* id_lip_l .*inh (100, id_rad_l.* inh(100, id_dich_l.* id_lat_l)))... %form lower face   Eqn 30 % CHECKED
                    .* inh (10,  id_early_p .* id_rim_l )... %inhibit rim to help with bending back    Eqn 32 % CHECKED
                    .* inh (0.5, id_late_p .* id_med_l.* id_lobe_l)... %reduce growth of midlobe   Eqn 38  % CHECKED
                    .* pro (2.4, id_early_p .* id_div_l.*id_plt_l )... %make lower tube arch over      Eqn 31 % CHECKED
                    .* inh (1, id_rad_l .*id_lip_l .* inh(3, id_dich_l .* id_lat_l))... %prevent lip growing at edge of dorsals   Eqn 26 % CHECKED
                    .* inh (1, id_rad_l .*id_plt_l .* inh(10, id_dich_l) .* inh (20, id_cyc_l .* inh (40, id_lat_l.^2)))... %prevent palate growing at edge of dorsals   Eqn 27 % CHECKED
                    .* pro (0.3, id_cyc_l .* id_dtl_l  .* inh (0.5, id_dich_l))... %promote growth of lateral dorsal lobe         Eqn 28 % CHECKED
                    .* pro (0.45, (id_cyc_l + 0.2* id_dich_l) .* id_plt_l)... %promote medial palate growth with CYC              Eqn 29 % CHECKED
                    .* pro (2.2, id_late_p .* id_lts_l .* id_med_l .* inh (0.5, id_lpb_l).* inh(4, id_lat_l) .*(id_lip_l + 0.3* id_plt_l))...%  promote lateral growth   Eqn 42 % CHECKED
                    ... %%%%%%% FINE TUNING %%%%%% better formed palate
                    .* inh (10,  id_late_p .* id_div_l .*id_cenorg_l.* inh(2, id_lpb_l).* pro (10, id_plt_l .* id_med_l))...% prevent lips protruding   Eqn 39
                    .* pro (0.2, id_late_p .* id_div_l .* id_plt_l)... %promote growth of palate   Eqn 40
                    .* inh (0.7, id_late_p .* id_lts_l .* id_lat_l .* (id_lip_l + id_plt_l)); %inhibit growth at edge of laterals   Eqn 41



%                 DKapar=1 ... %%%%%%% FINE TUNING %%%%%%
%                     .* inh (1, id_dich_l.* id_lat_l  .* id_lpb_l)...                               % Eqn 33
%                     .* inh (1, id_early_p .* (id_cyc_l + id_div_l) .*id_mlobe_l .* inh (5, id_dich_l))... %bend up distal lobes   Eqn 34
%                     .* pro (1, id_early_p .*  id_div_l .* id_lpb_l.* inh (5, id_med_l))... % bend out lips   Eqn 35

                %AKapar=0.05* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % bend back petals   Eqn 36 % CHECKED
                 
                %%%%%%% FINE TUNING %%%%%%
%                 DKbpar=pro (2, id_dich_l .* id_lat_l  .* id_lpb_l); % bend dorsal lip forward   Eqn 37  % CHECKED 

                % Background growth normal to the polariser   Eqn 201

                Kper=... % Eqn 250
                    0.0075 ... % Background growth normal to the polariser   Eqn 201
                    .* inh (0.2, id_prox_l)... %keep base small   Eqn 43   % CHECKED
                    .* pro(2, id_early_p .* id_dist_l .* inh (20, id_lat_l))... %  widen distal lobe    Eqn 46  % CHECKED
                    .* inh (0.3, id_late_p .* id_lobe_l .* id_med_l)... %keep medial lobe narrow   Eqn 50  % CHECKED
                    .* pro (1,   id_late_p .* id_dist_l .* pro (1.2, (id_cyc_l + id_div_l)))... % increase width of distal lobe   Eqn 49  % CHECKED
                    .* inh (1.3, id_late_p .* id_div_l .* inh(2.5, id_lobe_l.* inh (2,id_lpb_l)).* pro(1, id_plt_l))...  %narrow ventral petals    Eqn 51 %%%%%%% FINE TUNING %%%%%%
                    .* pro (0.1, id_cyc_l  .* pro(1.5,id_lip_l))... % increase width of dorsal petal    Eqn 44  % CHECKED
                    .* inh(6, id_early_p .* id_lts_l.*id_med_l )... %  keep laterals narrow initially   Eqn 45
                    .* pro (0.2, id_late_p .* id_lts_l .* id_med_l .*  id_plt_l); %promote growth of lateral width   Eqn 52   ADDD Fig 6G Model 3

                %%%%%%% FINE TUNING %%%%%%
%                 DKaper = pro (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 47
%                 DKbper = inh (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 48


                % compute the growth rates
                kapar=Kpar ...% Eqn 300
                    .* inh (1, id_dich_l.* id_lat_l  .* id_lpb_l)...                               % Eqn 33
                    .* inh (1, id_early_p .* (id_cyc_l + id_div_l) .*id_mlobe_l .* inh (5, id_dich_l))... %bend up distal lobes   Eqn 34
                    .* pro (1, id_early_p .*  id_div_l .* id_lpb_l.* inh (5, id_med_l))... % bend out lips   Eqn 35
                    +0.05* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % Eqn 301
                kbpar=Kpar ... % Eqn 310
                    .*pro (2, id_dich_l .* id_lat_l  .* id_lpb_l); % Eqn 37
                kaper=Kper ... % Eqn 320
                    .* pro (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 47
                kbper=Kper ... % Eqn 330
                    .*inh (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 48 
                knor =0.003; % thickness tracks model using Scaled USE KNOR(anti-curl) Eqn 305
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif strcmpi(modelnumber,'Fig 9B Model 7M1') % need to change cenorg to +organiser 
            % P EQUATIONS
            % START POLARISER section (it is slightly mixed with gene networks)
            m = leaf_mgen_conductivity( m, 's_distorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_distorg', 0.05);  % it will not decay everywhere
            m.globalProps.mingradient=0.01; % this ensures that all polariser gradients are frozen
            m = leaf_mgen_conductivity( m, 'Polariser', 0.002);% diffusion constant WAS 0.001
            m = leaf_mgen_dilution( m, 'Polariser', false );% it will not dilute with growth
            m = leaf_mgen_absorption( m, 'Polariser', 0.1);  % it will not decay everywhere

            m = leaf_mgen_conductivity( m, 's_cenorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_cenorg', 0.05);  % it will not decay everywhere

            %\latex \subsection{PRN (changes)}
            % POLARISER PRODUCTION
            if realtime>230 % From time 230  generate polariser
                id_proxorg_p = (id_prox_l >0.8);                                             % Eqn 2  CHECKED
                id_proxorg_l = id_proxorg_p * id_proxorg_a;
                %m.mgen_production(:,polariser_i) = 0.1 * (id_proxorg_l + 1 + 3*id_late_p.*id_cenorg_l);    % Eqn 18 and 19 production parts of  CHECKED
            end

            % POLARISER DECAY
            % switch on distorg with id_dist in the absence of id_lat
            if abs(realtime - 230) <0.5*dt % At time 230 hrs
%                 id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l);%  CHECKED % Eqn 3 (used in production equation)
%                 id_distorg_l = id_distorg_p * id_distorg_a;
%                 m.userdata.all_regions_ready=true;
                id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l)+ 0.1*(id_dich_l) .* id_dist_l .* id_cyc_l;           % Eqn 3 (used in production equation)
                id_distorg_l = id_distorg_p * id_distorg_a;
                m.userdata.all_regions_ready=true;
                v_dichdistorg_p=v_dichdistorg_p.*id_dich_l.* id_dist_l .* id_cyc_l;
            end
            
            if abs(realtime - 245) <0.5*dt %At 240 hrs
                %id_cenorg is activated by id_rim, id_lat and
                % id_div in absence of id_rad
                id_cenorg_p = 0.6*id_lat_l .* id_rim_l .* id_div_l ;                                   % Eqn 4 % CHECKED
                id_cenorg_l = id_cenorg_p * id_cenorg_a;
            end

            m.mgen_production(:,polariser_i) = 0.1 * (id_proxorg_l + 1 + 3*id_late_p.*id_cenorg_l - P .* (id_distorg_l)); % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE

            % LATER MODULATION OF DISTORG AND DIST
            % s_dist is activated by id_dist
            m.mgen_production(:,s_dist_i) = 0.1 * id_dist_l.* inh (100, id_lat_l);          % Eqn 17  CHECKED

            % s_distorg is activated by id_distorg
            m.mgen_production(:,s_distorg_i) = 0.1 * id_distorg_l ;                         % Eqn 15 (but  CHECKED

            % s_cenorg is activated by id_cenorg
            m.mgen_production(:,s_cenorg_i) = 0.1 * id_cenorg_l;                             % Eqn 16 % CHECKED

            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                id_cenorg_p = s_cenorg_l;                                                   % Eqn 11 % CHECKED
                id_cenorg_l = id_cenorg_p .* id_cenorg_a;
                id_distorg_p = s_distorg_l;                                                 % Eqn 12  CHECKED
                id_distorg_l = id_distorg_p .* id_distorg_a;
                id_dist_p = s_dist_l;                                                       % Eqn 13  CHECKED (NOT NEEDED IN THIS MODEL)
                id_dist_l = id_dist_p .* id_dist_a;
            end
            % End Polariser
            %\latex \subsection{GRN (changes)}

            % id_rad is activated by id_cyc and id_dich at ALL TIMES
            id_rad_p = id_cyc_l +  0.3* id_dich_l;                                           % Eqn 1 % CHECKED
            id_rad_l = id_rad_p * id_rad_a;

            % s_rad is activated by id_rad
            m.mgen_production(:,s_rad_i) = 0.1 * id_rad_l .* pro (0.5, id_tube_l);          % Eqn 14 % CHECKED

            % I suspect that it is the order within this set of equations that matters because
            % cenorg depends on div and rim in the setup secton that also happen
            % at 240
            if abs(realtime - 240) <0.5*dt %At 240 hrs
                % continue with the initial regionalisation
                % replace [0,1] values with reals for quantitative growth

                %switch on id_div
                id_div_p=inh(100, id_rad_l);                           % Eqn 5 % CHECKED
                id_div_l=id_div_p.*id_div_a;

                %id_laterals is activated by id_div
                id_lts_p(:) = id_div_l;                                                      % Eqn 6 % CHECKED
                id_lts_l=id_lts_p * id_lts_a;
            end

            if abs(realtime - 250) <0.5*dt % At time 250 hrs
                %id_cyc and id_dich are inhibited by id_div in absence of id_rad.
                %This is to ensure that in a id_rad mutant,
                %id_cyc and id_dich are inactivated. (Also see constitutive cyc
                %below)
                id_cyc_p = id_cyc_l.* inh (4, id_div_l );                                    % Eqn 7 % CHECKED
                id_cyc_l = id_cyc_p * id_cyc_a;

                id_dich_p = id_dich_l .* inh (4, id_div_l );                                 % Eqn 8 % CHECKED
                id_dich_l = id_dich_p * id_dich_a;

                % one shot setup regionalising lateral petals
                id_lts_p=5*id_lts_l.* s_rad_l;                                               % Eqn 9 % CHECKED
                id_lts_l=id_lts_p.*id_lts_a;
            end
            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                % narrow domain of div expression with id_laterals and id_rad at ~ 14 days
                id_div_p = id_div_l .* inh (5, id_lts_l);                                   % Eqn 10
                id_div_l = id_div_p.*id_div_a;
            end

            % End Gene Networks

            %\latex \subsection{KRN (changes)}
            if realtime >= 250 && realtime<570  % Between time 250 570
                % Compute growth rates

                % Note: the factors are vectors, one element per vertex (node)
                % as a result, with each statement, different things happen in
                % different regions of the model.
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                Kpar=... % Eqn 260
                    0.013 ... % Background growth parallel to the polariser  Eqn 200
                    .* inh (0.2, id_prox_l)... %keeps base small                              Eqn 24 % CHECKED
                    .* pro (0.4,id_tube_l .* inh (100, id_plt_l))... %promote growth of tube  Eqn 25 % CHECKED
                    .* pro (1.4, id_early_p .* id_lip_l .*inh (100, id_rad_l.* inh(100, id_dich_l.* id_lat_l)))... %form lower face   Eqn 30 % CHECKED
                    .* inh (10,  id_early_p .* id_rim_l )... %inhibit rim to help with bending back    Eqn 32 % CHECKED
                    .* inh (0.5, id_late_p .* id_med_l.* id_lobe_l)... %reduce growth of midlobe   Eqn 38  % CHECKED
                    .* pro (2.4, id_early_p .* id_div_l.*id_plt_l )... %make lower tube arch over      Eqn 31 % CHECKED
                    .* inh (1, id_rad_l .*id_lip_l .* inh(3, id_dich_l .* id_lat_l))... %prevent lip growing at edge of dorsals   Eqn 26 % CHECKED
                    .* inh (1, id_rad_l .*id_plt_l .* inh(10, id_dich_l) .* inh (20, id_cyc_l .* inh (40, id_lat_l.^2)))... %prevent palate growing at edge of dorsals   Eqn 27 % CHECKED
                    .* pro (0.3, id_cyc_l .* id_dtl_l  .* inh (0.5, id_dich_l))... %promote growth of lateral dorsal lobe         Eqn 28 % CHECKED
                    .* pro (0.45, (id_cyc_l + 0.2* id_dich_l) .* id_plt_l)... %promote medial palate growth with CYC              Eqn 29 % CHECKED
                    .* pro (2.2, id_late_p .* id_lts_l .* id_med_l .* inh (0.5, id_lpb_l).* inh(4, id_lat_l) .*(id_lip_l + 0.3* id_plt_l))...%  promote lateral growth   Eqn 42 % CHECKED
                    ... %%%%%%% FINE TUNING %%%%%% better formed palate
                    .* inh (10,  id_late_p .* id_div_l .*id_cenorg_l.* inh(2, id_lpb_l).* pro (10, id_plt_l .* id_med_l))...% prevent lips protruding   Eqn 39
                    .* pro (0.2, id_late_p .* id_div_l .* id_plt_l)... %promote growth of palate   Eqn 40
                    .* inh (0.7, id_late_p .* id_lts_l .* id_lat_l .* (id_lip_l + id_plt_l)); %inhibit growth at edge of laterals   Eqn 41



%                 DKapar=1 ... %%%%%%% FINE TUNING %%%%%%
%                     .* inh (1, id_dich_l.* id_lat_l  .* id_lpb_l)...                               % Eqn 33
%                     .* inh (1, id_early_p .* (id_cyc_l + id_div_l) .*id_mlobe_l .* inh (5, id_dich_l))... %bend up distal lobes   Eqn 34
%                     .* pro (1, id_early_p .*  id_div_l .* id_lpb_l.* inh (5, id_med_l))... % bend out lips   Eqn 35

                %AKapar=0.05* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % bend back petals   Eqn 36 % CHECKED
                 
                %%%%%%% FINE TUNING %%%%%%
%                 DKbpar=pro (2, id_dich_l .* id_lat_l  .* id_lpb_l); % bend dorsal lip forward   Eqn 37  % CHECKED 

                % Background growth normal to the polariser   Eqn 201

                Kper=... % Eqn 250
                    0.0075 ... % Background growth normal to the polariser   Eqn 201
                    .* inh (0.2, id_prox_l)... %keep base small   Eqn 43   % CHECKED
                    .* pro(2, id_early_p .* id_dist_l .* inh (20, id_lat_l))... %  widen distal lobe    Eqn 46  % CHECKED
                    .* inh (0.3, id_late_p .* id_lobe_l .* id_med_l)... %keep medial lobe narrow   Eqn 50  % CHECKED
                    .* pro (1,   id_late_p .* id_dist_l .* pro (1.2, (id_cyc_l + id_div_l)))... % increase width of distal lobe   Eqn 49  % CHECKED
                    .* inh (1.3, id_late_p .* id_div_l .* inh(2.5, id_lobe_l.* inh (2,id_lpb_l)).* pro(1, id_plt_l))...  %narrow ventral petals    Eqn 51 %%%%%%% FINE TUNING %%%%%%
                    .* pro (0.1, id_cyc_l  .* pro(1.5,id_lip_l))... % increase width of dorsal petal    Eqn 44  % CHECKED
                    .* inh(6, id_early_p .* id_lts_l.*id_med_l )... %  keep laterals narrow initially   Eqn 45
                    .* pro (0.2, id_late_p .* id_lts_l .* id_med_l .*  id_plt_l); %promote growth of lateral width   Eqn 52   ADDD Fig 6G Model 3

                %%%%%%% FINE TUNING %%%%%%
%                 DKaper = pro (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 47
%                 DKbper = inh (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 48


                % compute the growth rates
                kapar=Kpar ...% Eqn 300
                    .* inh (1, id_dich_l.* id_lat_l  .* id_lpb_l)...                               % Eqn 33
                    .* inh (1, id_early_p .* (id_cyc_l + id_div_l) .*id_mlobe_l .* inh (5, id_dich_l))... %bend up distal lobes   Eqn 34
                    .* pro (1, id_early_p .*  id_div_l .* id_lpb_l.* inh (5, id_med_l))... % bend out lips   Eqn 35
                    +0.05* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % Eqn 301
                kbpar=Kpar ... % Eqn 310
                    .*pro (2, id_dich_l .* id_lat_l  .* id_lpb_l); % Eqn 37
                kaper=Kper ... % Eqn 320
                    .* pro (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 47
                kbper=Kper ... % Eqn 330
                    .*inh (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 48 
                knor =0.003; % thickness tracks model using Scaled USE KNOR(anti-curl) Eqn 305
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif strcmpi(modelnumber,'Fig 9JK Model 8') %|| strcmpi(modelnumber,'Fig 9B Model 7M2') || strcmpi(modelnumber,'Fig 9B Model 7M3') 
            % P EQUATIONS
            % START POLARISER section (it is slightly mixed with gene networks)
            m = leaf_mgen_conductivity( m, 's_distorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_distorg', 0.05);  % it will not decay everywhere
            m.globalProps.mingradient=0.01; % this ensures that all polariser gradients are frozen
            m = leaf_mgen_conductivity( m, 'Polariser', 0.002);% diffusion constant WAS 0.001
            m = leaf_mgen_dilution( m, 'Polariser', false );% it will not dilute with growth
            m = leaf_mgen_absorption( m, 'Polariser', 0.1);  % it will not decay everywhere

            m = leaf_mgen_conductivity( m, 's_cenorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_cenorg', 0.05);  % it will not decay everywhere

            %\latex \subsection{PRN (changes)}
            % POLARISER PRODUCTION
            if realtime>230 % From time 230  generate polariser
                id_proxorg_p = (id_prox_l >0.8);                                             % Eqn 2  CHECKED
                id_proxorg_l = id_proxorg_p * id_proxorg_a;
            end

            % POLARISER DECAY
            % switch on distorg with id_dist in the absence of id_lat
            if abs(realtime - 230) <0.5*dt % At time 230 hrs
%                 id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l);%  CHECKED % Eqn 3 (used in production equation)
%                 id_distorg_l = id_distorg_p * id_distorg_a;
%                 m.userdata.all_regions_ready=true;
                id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l)+ 0.1*id_dich_l .* id_dist_l .* id_cyc_l;           % Eqn 3 (used in production equation)
                id_distorg_l = id_distorg_p * id_distorg_a;
                m.userdata.all_regions_ready=true;
                v_dichdistorg_p=v_dichdistorg_p.*id_dich_l.* id_dist_l .* id_cyc_l;
            end
            
            if abs(realtime - 245) <0.5*dt %At 240 hrs
                %id_cenorg is activated by id_rim, id_lat and
                % id_div in absence of id_rad
                %id_cenorg_p = 0.6*id_lat_l .* id_rim_l .* id_div_l ;                                   % Eqn 4 % CHECKED
                id_cenorg_p = 1*id_lat_l .* id_rim_l .* (0.03 * ones(size(id_cenorg_p))+0.57*id_div_l) ;   % MODIFIED        % Eqn 4 % CHECKED was 0.9*-.6
                %id_cenorg_p = 0.6*id_lat_l .* id_rim_l .* (0.05 * ones(size(id_cenorg_p))+0.9*id_div_l) ;   % MODIFIED        % Eqn 4 % CHECKED
                id_cenorg_l = id_cenorg_p * id_cenorg_a;
            end

            m.mgen_production(:,polariser_i) = 0.1 * (id_proxorg_l + 1 - P .* (id_distorg_l+3*id_late_p.*id_cenorg_l)); % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE
            %m.mgen_production(:,polariser_i) = m.mgen_production(:,polariser_i) - 0.1 * P .* (id_distorg_l+3*id_late_p.*id_cenorg_l);  % Eqn 19 decay part of WAS S_DISTORG BY MISTAKE

            % LATER MODULATION OF DISTORG AND DIST
            % s_dist is activated by id_dist
            m.mgen_production(:,s_dist_i) = 0.1 * id_dist_l.* inh (100, id_lat_l);          % Eqn 17  CHECKED

            % s_distorg is activated by id_distorg
            m.mgen_production(:,s_distorg_i) = 0.1 * id_distorg_l ;                         % Eqn 15 (but  CHECKED

            % s_cenorg is activated by id_cenorg
            m.mgen_production(:,s_cenorg_i) = 0.1 * id_cenorg_l;                             % Eqn 16 % CHECKED

            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                id_cenorg_p = s_cenorg_l;                                                   % Eqn 11 % CHECKED
                id_cenorg_l = id_cenorg_p .* id_cenorg_a;
                id_distorg_p = s_distorg_l;                                                 % Eqn 12  CHECKED
                id_distorg_l = id_distorg_p .* id_distorg_a;
                id_dist_p = s_dist_l;                                                       % Eqn 13  CHECKED (NOT NEEDED IN THIS MODEL)
                id_dist_l = id_dist_p .* id_dist_a;
            end
            % End Polariser
            %\latex \subsection{GRN (changes)}

            % id_rad is activated by id_cyc and id_dich at ALL TIMES
            id_rad_p = id_cyc_l +  0.3* id_dich_l;                                           % Eqn 1 % CHECKED
            id_rad_l = id_rad_p * id_rad_a;

            % s_rad is activated by id_rad
            m.mgen_production(:,s_rad_i) = 0.1 * id_rad_l .* pro (0.5, id_tube_l);          % Eqn 14 % CHECKED

            % I suspect that it is the order within this set of equations that matters because
            % cenorg depends on div and rim in the setup secton that also happen
            % at 240
            if abs(realtime - 240) <0.5*dt %At 240 hrs
                % continue with the initial regionalisation
                % replace [0,1] values with reals for quantitative growth

                %switch on id_div
                id_div_p=inh(100, id_rad_l);                           % Eqn 5 % CHECKED
                id_div_l=id_div_p.*id_div_a;

                %id_laterals is activated by id_div
                id_lts_p(:) = id_div_l;                                                      % Eqn 6 % CHECKED
                id_lts_l=id_lts_p * id_lts_a;
            end

            if abs(realtime - 250) <0.5*dt % At time 250 hrs
                %id_cyc and id_dich are inhibited by id_div in absence of id_rad.
                %This is to ensure that in a id_rad mutant,
                %id_cyc and id_dich are inactivated. (Also see constitutive cyc
                %below)
                id_cyc_p = id_cyc_l.* inh (4, id_div_l );                                    % Eqn 7 % CHECKED
                id_cyc_l = id_cyc_p * id_cyc_a;

                id_dich_p = id_dich_l .* inh (4, id_div_l );                                 % Eqn 8 % CHECKED
                id_dich_l = id_dich_p * id_dich_a;

                % one shot setup regionalising lateral petals
                id_lts_p=5*id_lts_l.* s_rad_l;                                               % Eqn 9 % CHECKED
                id_lts_l=id_lts_p.*id_lts_a;
            end
            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                % narrow domain of div expression with id_laterals and id_rad at ~ 14 days
                id_div_p = id_div_l .* inh (5, id_lts_l);                                   % Eqn 10
                id_div_l = id_div_p.*id_div_a;
            end

            % End Gene Networks

            %\latex \subsection{KRN (changes)}
            if realtime >= 250 && realtime<570  % Between time 250 570
                % Compute growth rates

                % Note: the factors are vectors, one element per vertex (node)
                % as a result, with each statement, different things happen in
                % different regions of the model.
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                Kpar=... % Eqn 260
                    0.013 ... % Background growth parallel to the polariser  Eqn 200
                    .* inh (0.2, id_prox_l)... %keeps base small                              Eqn 24 % CHECKED
                    .* pro (0.4,id_tube_l .* inh (100, id_plt_l))... %promote growth of tube  Eqn 25 % CHECKED
                    .* pro (1.4, id_early_p .* id_lip_l .*inh (100, id_rad_l.* inh(100, id_dich_l.* id_lat_l)))... %form lower face   Eqn 30 % CHECKED
                    .* inh (10,  id_early_p .* id_rim_l )... %inhibit rim to help with bending back    Eqn 32 % CHECKED
                    .* inh (0.5, id_late_p .* id_med_l.* id_lobe_l)... %reduce growth of midlobe   Eqn 38  % CHECKED
                    .* pro (2.4, id_early_p .* id_div_l.*id_plt_l )... %make lower tube arch over      Eqn 31 % CHECKED
                    .* inh (1, id_rad_l .*id_lip_l .* inh(3, id_dich_l .* id_lat_l))... %prevent lip growing at edge of dorsals   Eqn 26 % CHECKED
                    .* inh (1, id_rad_l .*id_plt_l .* inh(10, id_dich_l) .* inh (20, id_cyc_l .* inh (40, id_lat_l.^2)))... %prevent palate growing at edge of dorsals   Eqn 27 % CHECKED
                    .* pro (0.3, id_cyc_l .* id_dtl_l  .* inh (0.5, id_dich_l))... %promote growth of lateral dorsal lobe         Eqn 28 % CHECKED
                    .* pro (0.45, (id_cyc_l + 0.2* id_dich_l) .* id_plt_l)... %promote medial palate growth with CYC              Eqn 29 % CHECKED
                    .* pro (2.2, id_late_p .* id_lts_l .* id_med_l .* inh (0.5, id_lpb_l).* inh(4, id_lat_l) .*(id_lip_l + 0.3* id_plt_l))...%  promote lateral growth   Eqn 42 % CHECKED
                    ... %%%%%%% FINE TUNING %%%%%% better formed palate
                    .* inh (10,  id_late_p .* id_div_l .*id_cenorg_l.* inh(2, id_lpb_l).* pro (10, id_plt_l .* id_med_l))...% prevent lips protruding   Eqn 39
                    .* pro (0.2, id_late_p .* id_div_l .* id_plt_l)... %promote growth of palate   Eqn 40
                    .* inh (0.7, id_late_p .* id_lts_l .* id_lat_l .* (id_lip_l + id_plt_l)); %inhibit growth at edge of laterals   Eqn 41



%                 DKapar=1 ... %%%%%%% FINE TUNING %%%%%%
%                     .* inh (1, id_dich_l.* id_lat_l  .* id_lpb_l)...                               % Eqn 33
%                     .* inh (1, id_early_p .* (id_cyc_l + id_div_l) .*id_mlobe_l .* inh (5, id_dich_l))... %bend up distal lobes   Eqn 34
%                     .* pro (1, id_early_p .*  id_div_l .* id_lpb_l.* inh (5, id_med_l))... % bend out lips   Eqn 35

                %AKapar=0.05* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % bend back petals   Eqn 36 % CHECKED
                 
                %%%%%%% FINE TUNING %%%%%%
%                 DKbpar=pro (2, id_dich_l .* id_lat_l  .* id_lpb_l); % bend dorsal lip forward   Eqn 37  % CHECKED 

                % Background growth normal to the polariser   Eqn 201

                Kper=... % Eqn 250
                    0.0075 ... % Background growth normal to the polariser   Eqn 201
                    .* inh (0.2, id_prox_l)... %keep base small   Eqn 43   % CHECKED
                    .* pro(2, id_early_p .* id_dist_l .* inh (20, id_lat_l))... %  widen distal lobe    Eqn 46  % CHECKED
                    .* inh (0.3, id_late_p .* id_lobe_l .* id_med_l)... %keep medial lobe narrow   Eqn 50  % CHECKED
                    .* pro (1,   id_late_p .* id_dist_l .* pro (1.2, (id_cyc_l + id_div_l)))... % increase width of distal lobe   Eqn 49  % CHECKED
                    .* inh (1.3, id_late_p .* id_div_l .* inh(2.5, id_lobe_l.* inh (2,id_lpb_l)).* pro(1, id_plt_l))...  %narrow ventral petals    Eqn 51 %%%%%%% FINE TUNING %%%%%%
                    .* pro (0.1, id_cyc_l  .* pro(1.5,id_lip_l))... % increase width of dorsal petal    Eqn 44  % CHECKED
                    .* inh(6, id_early_p .* id_lts_l.*id_med_l )... %  keep laterals narrow initially   Eqn 45
                    .* pro (0.2, id_late_p .* id_lts_l .* id_med_l .*  id_plt_l); %promote growth of lateral width   Eqn 52   ADDD Fig 6G Model 3

                %%%%%%% FINE TUNING %%%%%%
%                 DKaper = pro (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 47
%                 DKbper = inh (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 48


                % compute the growth rates
                kapar=Kpar ...% Eqn 300
                    .* inh (1, id_dich_l.* id_lat_l  .* id_lpb_l)...                               % Eqn 33
                    .* inh (1, id_early_p .* (id_cyc_l + id_div_l) .*id_mlobe_l .* inh (5, id_dich_l))... %bend up distal lobes   Eqn 34
                    .* pro (1, id_early_p .*  id_div_l .* id_lpb_l.* inh (5, id_med_l))... % bend out lips   Eqn 35
                    +0.05* id_early_p .* id_rim_l .* ( 0.7*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_dich_l)+0.5*ones(size(id_cenorg_l)));% NEW  % Eqn 301
                    %+0.05* id_early_p .* id_rim_l .* (0.85*( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l))+0.5*ones(size(id_cenorg_l)));% NEW  % Eqn 301
                    %+0.05* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % Eqn 301
                kbpar=Kpar ... % Eqn 310
                    .*pro (2, id_dich_l .* id_lat_l  .* id_lpb_l); % Eqn 37
                kaper=Kper ... % Eqn 320
                    .* pro (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 47
                kbper=Kper ... % Eqn 330
                    .*inh (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 48 
                knor =0.003; % thickness tracks model using Scaled USE KNOR(anti-curl) Eqn 305
            end
        elseif strcmpi(modelnumber,'WILD') % The WILD model retains the mutantnumber options needed for Minlong paper
            % P polariser equations
            % Start Polariser section (it is slightly mixed with gene networks)
            m = leaf_mgen_conductivity( m, 's_distorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_distorg', 0.05);  % it will not decay everywhere
            m = leaf_mgen_conductivity( m, 's_cenorg', 0.002); %was 0.1 distorg_diff);% diffusion constant
            m = leaf_mgen_absorption( m, 's_cenorg', 0.05);  % it will not decay everywhere
            m.globalProps.mingradient=0.01; % this ensures that all polariser gradients are frozen
            m = leaf_mgen_conductivity( m, 'Polariser', 0.002);% diffusion constant WAS 0.001
            m = leaf_mgen_dilution( m, 'Polariser', false );% it will not dilute with growth
            m = leaf_mgen_absorption( m, 'Polariser', 0.1);  % it will not decay everywhere

               %%%%%%% The polariser
            if realtime>230 % From time 230  generate polariser
                id_proxorg_p = (id_prox_l >0.8);                                             % Eqn 2
                %  id_proxorg_p = id_prox_l;
                id_proxorg_l = id_proxorg_p * id_proxorg_a;
            end

            % switch on distorg with id_dist in the absence of id_lat
            % and enhance with dich in presence of cyc
            if abs(realtime - 230) <0.5*dt % At time 230 hrs
                if mutantnumber==3
                    id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l);
                else
                    id_distorg_p = 0.25* id_dist_l .* inh (100, id_lat_l)+ 0.1*(id_dich_l) .* id_dist_l .* id_cyc_l;         % Eqn 3 (used in production equation)
                end
                id_distorg_l = id_distorg_p * id_distorg_a;
                m.userdata.all_regions_ready=true;
            end
            
            if abs(realtime - 245) <0.5*dt %At 240 hrs
                %id_cenorg is activated by id_rim, id_lat and
                % id_div in absence of id_rad
                id_cenorg_p = 0.6*id_lat_l .* id_rim_l .* id_div_l ;                                   % Eqn 4 % CHECKED
                id_cenorg_l = id_cenorg_p * id_cenorg_a;
            end

            if mutantnumber==1
                m.mgen_production(:,polariser_i) = 0;
                disp('no polariser')
            elseif mutantnumber==2
                m.mgen_production(:,polariser_i) = 0.1 * (id_proxorg_l + 1 - P .* (id_distorg_l+3*id_cenorg_l));
                disp('use distorg and cenorg to update polariser from the beginning')
            else
                m.mgen_production(:,polariser_i) = 0.1 * (id_proxorg_l + 1 - P .* (id_distorg_l+3*id_late_p.*id_cenorg_l));                   % Eqn 19 decay part of
                disp('update polariser without cenorg until 340')
            end

            %option for id_cyc being constitutive also see above realtime<250
            if mutantnumber==5 || mutantnumber==6
                id_cyc_p=ones(size(id_cyc_p));
                id_cyc_l=id_cyc_p.*id_cyc_a;
            end

            % s_dist is activated by id_dist
            m.mgen_production(:,s_dist_i) = 0.1 * id_dist_l.* inh (100, id_lat_l);          % Eqn 17

            % s_distorg is activated by id_distorg
            m.mgen_production(:,s_distorg_i) = 0.1 * id_distorg_l ;                         % Eqn 15 (but
            % note that distorg is set elsewhere) the 0.1 seems to be an error

            % s_cenorg is activated by id_cenorg
            m.mgen_production(:,s_cenorg_i) = 0.1 * id_cenorg_l;                            % Eqn 16



            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                id_cenorg_p = s_cenorg_l;                                                   % Eqn 11
                id_cenorg_l = id_cenorg_p .* id_cenorg_a;
                id_distorg_p = s_distorg_l;                                                 % Eqn 12
                id_distorg_l = id_distorg_p .* id_distorg_a;
                id_dist_p = s_dist_l;                                                       % Eqn 13
                id_dist_l = id_dist_p .* id_dist_a;
             end

            %             end
            % End Polariser

            % Start Gene Networks
            % id_rad is activated by id_cyc and id_dich at ALL TIMES
            id_rad_p = id_cyc_l +  0.3* id_dich_l;                                           % Eqn 1
            id_rad_l = id_rad_p * id_rad_a;

            if mutantnumber==4 || mutantnumber==6
                % option for id_rad being constitutive
                id_rad_p=ones(size(id_rad_p));
                id_rad_l=id_rad_p; % REMOVED this otherwise rad deficient looses constitutive .*id_rad_a;
            end
            % s_rad is activated by id_rad
            m.mgen_production(:,s_rad_i) = 0.1 * id_rad_l .* pro (0.5, id_tube_l);          % Eqn 14

            % I suspect that it is the order within this set of equations that matters because
            % cenorg depends on div and rim in the setup secton that also happen
            % at 240
            if abs(realtime - 240) <0.5*dt %At 240 hrs
                % continue with the initial regionalisation
                % replace [0,1] values with reals for quantitative growth

                %switch on id_div
                id_div_p=ones(size(id_div_p)).*inh(100, id_rad_l);                           % Eqn 5
                id_div_l=id_div_p.*id_div_a;

                %id_laterals is activated by id_div
                id_lts_p(:) = id_div_l;                                                      % Eqn 6
                id_lts_l=id_lts_p * id_lts_a;
                %id_cenorg is activated by id_rim, id_lat and
                % id_div in absence of id_rad
                id_cenorg_p = 0.6*id_lat_l .* id_rim_l .* id_div_l ;                                   % Eqn 4
                id_cenorg_l = id_cenorg_p * id_cenorg_a;
            end

            if abs(realtime - 250) <0.5*dt % At time 250 hrs
                %id_cyc and id_dich are inhibited by id_div in absence of id_rad.
                %This is to ensure that in a id_rad mutant,
                %id_cyc and id_dich are inactivated. (Also see constitutive cyc
                %below)
                id_cyc_p = id_cyc_l.* inh (4, id_div_l );                                    % Eqn 7
                id_cyc_l = id_cyc_p * id_cyc_a;

                id_dich_p = id_dich_l .* inh (4, id_div_l );                                 % Eqn 8
                id_dich_l = id_dich_p * id_dich_a;

                % one shot setup regionalising lateral petals
                id_lts_p=5*id_lts_l.* s_rad_l;                                               % Eqn 9
                id_lts_l=id_lts_p.*id_lts_a;
            end
            if abs(realtime - 340) <0.5*dt % At time 340 hrs
                % narrow domain of div expression with id_laterals and id_rad at ~ 14 days
                id_div_p = id_div_l .* inh (5, id_lts_l);                                   % Eqn 10
                id_div_l = id_div_p.*id_div_a;
            end
            % End Gene Networks

            % GROWTH MODEL BEGINS HERE
            if realtime >= 250 && realtime<570  % Between time 250 570
                % Compute growth rates

                Kpar=... % Eqn 260
                    0.013 ... % Background growth parallel to the polariser  Eqn 200
                    .* inh (0.2, id_prox_l)... %keeps base small                              Eqn 24 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    .* pro (0.4,id_tube_l .* inh (100, id_plt_l))... %promote growth of tube  Eqn 25
                    .* inh (1, id_rad_l .*id_lip_l .* inh(3, id_dich_l .* id_lat_l))... %prevent lip growing at edge of dorsals   Eqn 26
                    .* inh (1, id_rad_l .*id_plt_l .* inh(10, id_dich_l) .* inh (20, id_cyc_l .* inh (40, id_lat_l.^2)))... %prevent palate growing at edge of dorsals   Eqn 27
                    .* pro (0.3, id_cyc_l .* id_dtl_l  .* inh (0.5, id_dich_l))... %promote growth of lateral dorsal lobe   Eqn 28
                    .* pro (0.45, (id_cyc_l + 0.2* id_dich_l) .* id_plt_l)... %promote medial palate growth with CYC   Eqn 29
                    ...
                    .* pro (1.4, id_early_p .* id_lip_l .*inh (100, id_rad_l.* inh(100, id_dich_l.* id_lat_l)))... %form lower face   Eqn 30
                    .* pro (2.4, id_early_p .* id_div_l.*id_plt_l )... %make lower tube arch over  Eqn 31
                    .* inh (10,  id_early_p .* id_rim_l )... %inhibit rim to help with bending back    Eqn 32
                    ...
                    .* inh (0.5, id_late_p .* id_med_l.* id_lobe_l)... %reduce growth of midlobe   Eqn 38
                    .* inh (10,  id_late_p .* id_div_l .*id_cenorg_l.* inh(2, id_lpb_l).* pro (10, id_plt_l .* id_med_l))...% prevent lips protruding   Eqn 39
                    .* pro (0.2, id_late_p .* id_div_l .* id_plt_l)... %promote growth of palate   Eqn 40
                    .* inh (0.7, id_late_p .* id_lts_l .* id_lat_l .* (id_lip_l + id_plt_l))... %inhibit growth at edge of laterals   Eqn 41
                    .* pro (2.2, id_late_p .* id_lts_l .* id_med_l .* inh (0.5, id_lpb_l).* inh(4, id_lat_l) .*(id_lip_l + 0.3* id_plt_l));%  promote lateral growth   Eqn 42

%                 DKapar=1 ...
%                     .* inh (1, id_dich_l.* id_lat_l  .* id_lpb_l)...                               % Eqn 33
%                     .* inh (1, id_early_p .* (id_cyc_l + id_div_l) .*id_mlobe_l .* inh (5, id_dich_l))... %bend up distal lobes   Eqn 34
%                     .* pro (1, id_early_p .*  id_div_l .* id_lpb_l.* inh (5, id_med_l))... % bend out lips   Eqn 35
                %AKapar=0.05* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % bend back petals   Eqn 36

%                DKbpar=pro (2, id_dich_l .* id_lat_l  .* id_lpb_l); % bend dorsal lip forward  Eqn 37

                % Background growth normal to the polariser   Eqn 201

                Kper=... % Eqn 250
                    0.0075 ... % Background growth normal to the polariser   Eqn 201
                    .* inh (0.2, id_prox_l)... %keep base small   Eqn 43
                    .* pro (0.1, id_cyc_l  .* pro(1.5,id_lip_l))... % increase width of dorsal petal   Eqn 44
                    ...
                    .* inh(6, id_early_p .* id_lts_l.*id_med_l )... %  keep laterals narrow initially  Eqn 45
                    .* pro(2, id_early_p .* id_dist_l .* inh (20, id_lat_l))... %  widen distal lobe   Eqn 46
                    ...
                    .* pro (1,   id_late_p .* id_dist_l .* pro (1.2, (id_cyc_l + id_div_l)))... % increase width of distal lobe   Eqn 49
                    .* inh (0.3, id_late_p .* id_lobe_l .* id_med_l)... %keep medial lobe narrow   Eqn 50
                    .* inh (1.3, id_late_p .* id_div_l .* inh(2.5, id_lobe_l.* inh (2,id_lpb_l)).* pro(1, id_plt_l))...  %narrow ventral petals    Eqn 51
                    .* pro (0.2, id_late_p .* id_lts_l .* id_med_l .*  id_plt_l); %promote growth of lateral width   Eqn 52

%                 DKaper = pro (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 47
%                 DKbper = inh (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 48

                % compute the growth rates
%                 kapar=Kpar .*DKapar ... % Eqn 300
%                     +0.05* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % Eqn 301
%                 kbpar=Kpar .*DKbpar; % Eqn 310
%                 kaper=Kper .*DKaper; % Eqn 320
%                 kbper=Kper .*DKbper; % Eqn 330
%                 knor =0.003; % thickness tracks model using Scaled USE KNOR(anti-curl) Eqn 305
                kapar=Kpar ...% Eqn 300
                    .* inh (1, id_dich_l.* id_lat_l  .* id_lpb_l)...                               % Eqn 33
                    .* inh (1, id_early_p .* (id_cyc_l + id_div_l) .*id_mlobe_l .* inh (5, id_dich_l))... %bend up distal lobes   Eqn 34
                    .* pro (1, id_early_p .*  id_div_l .* id_lpb_l.* inh (5, id_med_l))... % bend out lips   Eqn 35
                    +0.05* id_early_p .* id_rim_l .* ( 1.2*id_div_l + 0.3* id_lts_l.* id_med_l  + 0.5*(id_cyc_l +id_dich_l)); % Eqn 301
                kbpar=Kpar ... % Eqn 310
                    .*pro (2, id_dich_l .* id_lat_l  .* id_lpb_l); % Eqn 37
                kaper=Kper ... % Eqn 320
                    .* pro (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 47
                kbper=Kper ... % Eqn 330
                    .*inh (1, id_early_p .* id_div_l .* id_lpb_l.* inh (3, id_med_l));%bend out lips;   Eqn 48 
                knor =0.003; % thickness tracks model using Scaled USE KNOR(anti-curl) Eqn 305
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if realtime >= 250 && realtime<570  % Between time 250 570
                kapar_p=kapar;
                kbpar_p=kbpar;
                kaper_p=kaper;
                kbper_p=kbper; 
                knor_p =knor; 
        end
        % Growth factors cannot be negative.
        if realtime>250
            kapar_p = max( kapar_p, 0 );
            kbpar_p = max( kbpar_p, 0 );
            kaper_p = max( kaper_p, 0 );
            kbper_p = max( kbper_p, 0 );
        end
        % Reconstruct the old growth and bend morphogens.
        kpar_p = (kapar_p + kbpar_p)/2;
        kper_p = (kaper_p + kbper_p)/2;
        bendpar_p = kbpar_p - kpar_p;
        bendper_p = kbper_p - kper_p;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        if realtime>570 % finished growth
            % just increment time to allow flattened results to be saved
            kapar_p = 0;
            kbpar_p = 0;
            kaper_p = 0;
            kbper_p = 0;
        end

        % dissect the corolla for flattening
        %         if realtime==570 %(570>realtime-dt) && (570<realtime+dt)
        %                     lateral_protect=double(id_div_p>0.2 & id_div_p<0.536);%536);
        %                     f_seam4_p=lateral_protect;
        %                     dorsal_protect=(id_div_p<0.01);
        %                     f_seam4_p=dorsal_protect;
        %                     f_seam_p=f_seppetals_p + f_sepbase_p + f_seplobes2_p .* (f_seam3_p+lateral_protect);
        %                     m=leaf_set_seams(m,f_seam_p);
        %         elseif realtime==(570+dt)
        % USE this for separate parts
        f_seam_p(:)=0;
        f_seam_p=f_seppetals_p + f_sepbase_p + f_seplobes2_p ;
        %f_seam_p=f_seppetals_p + f_sepbase_p ;
        m=leaf_set_seams(m,f_seam_p);
        %         elseif realtime==(570+2*dt)
        %             f_seam_p=f_seppetals_p + f_sepbase_p + f_seplobes2_p ;
        %             m=leaf_set_seams(m,f_seam_p);
        %         end

        % Calculate the area, excluding the base.
        areaCells = any( id_prox_p( m.tricellvxs )==0, 2 );
        % These are the finite elements which have at least one vertex where
        % the id_prox morphogen is zero.

        nonBaseArea = sum( m.cellareas( areaCells ) );
        % This is the total area of these finite elements.

        fprintf( 1, 'Snapdragon area At %.3f, excluding the base = %.3f sq mm, including base = %.3f sq mm\n', ...
            realtime, nonBaseArea, sum( m.cellareas ) );

        % Calculate the area, excluding the base.
        nonBaseCells = any( id_prox_p( m.tricellvxs )==0, 2 );
        % These are the finite elements which have at least one vertex where
        % the id_prox morphogen is zero.
        nonBaseArea = sum( m.cellareas( nonBaseCells ) );
        % This is the total area of these finite elements.
        m.userdata.areas(m.globalDynamicProps.currentIter+1) = nonBaseArea;
        m.userdata.times(m.globalDynamicProps.currentIter+1) = realtime;

    end
%%% END OF USER CODE: MORPHOGEN INTERACTIONS

%%% SECTION 3: INSTALLING MODIFIED VALUES BACK INTO MESH STRUCTURE
%%% AUTOMATICALLY GENERATED CODE: DO NOT EDIT.
    m.morphogens(:,polariser_i) = P;
    m.morphogens(:,kapar_i) = kapar_p;
    m.morphogens(:,kaper_i) = kaper_p;
    m.morphogens(:,kbpar_i) = kbpar_p;
    m.morphogens(:,kbper_i) = kbper_p;
    m.morphogens(:,knor_i) = knor_p;
    m.morphogens(:,strainret_i) = strainret_p;
    m.morphogens(:,arrest_i) = arrest_p;
    m.morphogens(:,id_rad_i) = id_rad_p;
    m.morphogens(:,id_div_i) = id_div_p;
    m.morphogens(:,id_dich_i) = id_dich_p;
    m.morphogens(:,id_cyc_i) = id_cyc_p;
    m.morphogens(:,id_distorg_i) = id_distorg_p;
    m.morphogens(:,id_lat_i) = id_lat_p;
    m.morphogens(:,id_lobe_i) = id_lobe_p;
    m.morphogens(:,id_dist_i) = id_dist_p;
    m.morphogens(:,v_theta_i) = v_theta_p;
    m.morphogens(:,id_tube_i) = id_tube_p;
    m.morphogens(:,id_rim_i) = id_rim_p;
    m.morphogens(:,id_prox_i) = id_prox_p;
    m.morphogens(:,id_lip_i) = id_lip_p;
    m.morphogens(:,kpar_i) = kpar_p;
    m.morphogens(:,kper_i) = kper_p;
    m.morphogens(:,bendpar_i) = bendpar_p;
    m.morphogens(:,bendper_i) = bendper_p;
    m.morphogens(:,s_prox_i) = s_prox_p;
    m.morphogens(:,s_lat_i) = s_lat_p;
    m.morphogens(:,id_lpb_i) = id_lpb_p;
    m.morphogens(:,f_seam_i) = f_seam_p;
    m.morphogens(:,f_hole_i) = f_hole_p;
    m.morphogens(:,f_lat2_i) = f_lat2_p;
    m.morphogens(:,id_lts_i) = id_lts_p;
    m.morphogens(:,s_rad_i) = s_rad_p;
    m.morphogens(:,s_cenorg_i) = s_cenorg_p;
    m.morphogens(:,id_cenorg_i) = id_cenorg_p;
    m.morphogens(:,id_med_i) = id_med_p;
    m.morphogens(:,v_flower_i) = v_flower_p;
    m.morphogens(:,s_med_i) = s_med_p;
    m.morphogens(:,s_distorg_i) = s_distorg_p;
    m.morphogens(:,id_uptube_i) = id_uptube_p;
    m.morphogens(:,id_proxorg_i) = id_proxorg_p;
    m.morphogens(:,id_plt_i) = id_plt_p;
    m.morphogens(:,id_dtl_i) = id_dtl_p;
    m.morphogens(:,f_seam2_i) = f_seam2_p;
    m.morphogens(:,s_lpb_i) = s_lpb_p;
    m.morphogens(:,id_mlobe_i) = id_mlobe_p;
    m.morphogens(:,s_dist_i) = s_dist_p;
    m.morphogens(:,f_seppetals_i) = f_seppetals_p;
    m.morphogens(:,f_sepbase_i) = f_sepbase_p;
    m.morphogens(:,f_seplobes1_i) = f_seplobes1_p;
    m.morphogens(:,f_seplobes2_i) = f_seplobes2_p;
    m.morphogens(:,f_seplobes3_i) = f_seplobes3_p;
    m.morphogens(:,f_seam3_i) = f_seam3_p;
    m.morphogens(:,f_seam4_i) = f_seam4_p;
    m.morphogens(:,f_seamventral_i) = f_seamventral_p;
    m.morphogens(:,f_seamdorsal_i) = f_seamdorsal_p;
    m.morphogens(:,id_early_i) = id_early_p;
    m.morphogens(:,id_late_i) = id_late_p;
    m.morphogens(:,v_dichdistorg_i) = v_dichdistorg_p;
    m.morphogens(:,v_cenorgn_i) = v_cenorgn_p;
    m.morphogens(:,v_cenorgp_i) = v_cenorgp_p;

%%% USER CODE: FINALISATION

    % force FE to subdivide here
    % sometimes it is convenient to switch of subdivision
    % until regionalisation is complete
    if  m.userdata.all_regions_ready
        % but in any case only do it when the particular region
        % is ready and has not already been subdivided
        if max(id_lip_p)>=0.75 %&& ~isfield(m.userdata,'donesubdivision2')
            m = leaf_subdivide( m, 'morphogen','id_lip',...
                'min',0.5,'max',1,...
                'mode','mid','levels','all');
        end

        % one shot subdivision
        m.userdata.all_regions_ready=false;
        m.userdata.donesubdivisions=true;
    end
%%% END OF USER CODE: FINALISATION

end


%%% USER CODE: SUBFUNCTIONS
% Here you may add any functions of your own, that you want to call from
% the interaction function, but never need to call from outside it.
% Whichever section they are called from, they must respect the same
% restrictions on what modifications they are allowed to make to the mesh.
% This comment can be deleted.
function m=leaf_set_seams(m,f_seam_p)
    seamnodes=find(f_seam_p>0.5);
    % use m.edgeends, m.seams, m.nodes
    % find nodes to be included in seams
    % find edges joining the nodes
    jn=[];
    for i=1:length(m.edgeends)
        ind=intersect(seamnodes,m.edgeends(i,:));
        if length(ind)==2
            jn(end+1)=i;
        end
    end
    % set all seams
    m.seams=false(size(m.edgeends,1),1);
    m.seams(jn)=true;
end

function [m,f_seam_p,f_seam2_p]=remove_lip_seams(m,id_lip_p,id_lat_p,f_seam_p,f_seam2_p)
    %function m=remove_lip_seams(m,id_lip_p,id_lat_p,f_seam_p)
    %
    % add the following 3 lines to the interaction function and
    % this function to the end of the interaction function
    %
    %     if (570>realtime-dt) && (570<realtime+dt)
    %         m=remove_lip_seams(m,id_lip_p,id_lat_p,f_seam_p);
    %     end
    ind=find(id_lip_p>0 & f_seam_p>0); %7);
    f_seam2_p(ind)=1; % keep this seam for later
    ind=find(id_lip_p>0 & id_lat_p<0.4); %7);
    f_seam_p(ind)=0; %%%%%%%%%%%%%% REMOVE %%%%%%%%%%%%%
    seamnodes=find(f_seam_p>0.5);
    % find edges joining the nodes
    jn=[];
    for i=1:length(m.edgeends)
        ind=intersect(seamnodes,m.edgeends(i,:));
        if length(ind)==2
            jn(end+1)=i;
        end
    end
    % set seams
    m.seams=false(size(m.edgeends,1),1);
    m.seams(jn)=true;
end
function [m,f_seam2_p]=remove_lip_seams2(m,f_seam2_p)
    %
    %     if (570>realtime-dt) && (570<realtime+dt)
    %         m=remove_lip_seams2(m,f_seam2_p);
    %     end
    seamnodes=find(f_seam2_p>0.5);
    % find edges joining the nodes
    jn=[];
    for i=1:length(m.edgeends)
        ind=intersect(seamnodes,m.edgeends(i,:));
        if length(ind)==2
            jn(end+1)=i;
        end
    end
    % set seams
    m.seams=false(size(m.edgeends,1),1);
    m.seams(jn)=true;
end


