/*
 *                                                        ____  _____
 *                            ________  _________  ____  / __ \/ ___/
 *                           / ___/ _ \/ ___/ __ \/ __ \/ / / /\__ \
 *                          / /  /  __/ /__/ /_/ / / / / /_/ /___/ /
 *                         /_/   \___/\___/\____/_/ /_/\____//____/
 *
 * ======================================================================
 *
 *   title:        Application library
 *
 *   project:      ReconOS
 *   author:       Andreas Agne, University of Paderborn
 *                 Christoph Rüthing, University of Paderborn
 *   description:  Auto-generated application specific header file
 *                 including definitions of all resources and functions
 *                 to instantiate resources and threads automatically.
 *
 * ======================================================================
 */



#include "reconos_app.h"

#include "reconos.h"
#include "utils.h"

/* == Application resources ============================================ */

/*
 * @see header
 */
struct mbox resources_inittcpipserver_s;
struct mbox *resources_inittcpipserver = &resources_inittcpipserver_s;

struct mbox resources_initfeatureextractionmanagersw_s;
struct mbox *resources_initfeatureextractionmanagersw = &resources_initfeatureextractionmanagersw_s;

struct mbox resources_initfeatureextractionmanagerhw_s;
struct mbox *resources_initfeatureextractionmanagerhw = &resources_initfeatureextractionmanagerhw_s;

struct mbox resources_initfeatureprojection_s;
struct mbox *resources_initfeatureprojection = &resources_initfeatureprojection_s;

struct mbox resources_initlda_s;
struct mbox *resources_initlda = &resources_initlda_s;

struct mbox resources_initclassification_s;
struct mbox *resources_initclassification = &resources_initclassification_s;

struct mbox resources_samplewindowsw_s;
struct mbox *resources_samplewindowsw = &resources_samplewindowsw_s;

struct mbox resources_samplewindowhw_s;
struct mbox *resources_samplewindowhw = &resources_samplewindowhw_s;

struct mbox resources_featurewindow_s;
struct mbox *resources_featurewindow = &resources_featurewindow_s;

struct mbox resources_mavmav_s;
struct mbox *resources_mavmav = &resources_mavmav_s;

struct mbox resources_projectedfeatures_s;
struct mbox *resources_projectedfeatures = &resources_projectedfeatures_s;

struct mbox resources_acknowledgementclassification_s;
struct mbox *resources_acknowledgementclassification = &resources_acknowledgementclassification_s;

struct mbox resources_ldatrainingdataset_s;
struct mbox *resources_ldatrainingdataset = &resources_ldatrainingdataset_s;

struct mbox resources_ldaprojectionmatrix_s;
struct mbox *resources_ldaprojectionmatrix = &resources_ldaprojectionmatrix_s;

struct mbox resources_ldaclassmeans_s;
struct mbox *resources_ldaclassmeans = &resources_ldaclassmeans_s;









struct reconos_resource resources_inittcpipserver_res = {
	.ptr = &resources_inittcpipserver_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_initfeatureextractionmanagersw_res = {
	.ptr = &resources_initfeatureextractionmanagersw_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_initfeatureextractionmanagerhw_res = {
	.ptr = &resources_initfeatureextractionmanagerhw_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_initfeatureprojection_res = {
	.ptr = &resources_initfeatureprojection_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_initlda_res = {
	.ptr = &resources_initlda_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_initclassification_res = {
	.ptr = &resources_initclassification_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_samplewindowsw_res = {
	.ptr = &resources_samplewindowsw_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_samplewindowhw_res = {
	.ptr = &resources_samplewindowhw_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_featurewindow_res = {
	.ptr = &resources_featurewindow_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_mavmav_res = {
	.ptr = &resources_mavmav_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_projectedfeatures_res = {
	.ptr = &resources_projectedfeatures_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_acknowledgementclassification_res = {
	.ptr = &resources_acknowledgementclassification_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_ldatrainingdataset_res = {
	.ptr = &resources_ldatrainingdataset_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_ldaprojectionmatrix_res = {
	.ptr = &resources_ldaprojectionmatrix_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};

struct reconos_resource resources_ldaclassmeans_res = {
	.ptr = &resources_ldaclassmeans_s,
	.type = RECONOS_RESOURCE_TYPE_MBOX
};




/* == Application functions ============================================ */

/*
 * @see header
 */
void reconos_app_init() {
		mbox_init(resources_inittcpipserver, 128);
		mbox_init(resources_initfeatureextractionmanagersw, 128);
		mbox_init(resources_initfeatureextractionmanagerhw, 128);
		mbox_init(resources_initfeatureprojection, 128);
		mbox_init(resources_initlda, 128);
		mbox_init(resources_initclassification, 128);
		mbox_init(resources_samplewindowsw, 128);
		mbox_init(resources_samplewindowhw, 128);
		mbox_init(resources_featurewindow, 128);
		mbox_init(resources_mavmav, 128);
		mbox_init(resources_projectedfeatures, 128);
		mbox_init(resources_acknowledgementclassification, 128);
		mbox_init(resources_ldatrainingdataset, 128);
		mbox_init(resources_ldaprojectionmatrix, 128);
		mbox_init(resources_ldaclassmeans, 128);
	

	

	

	
}

/*
 * @see header
 */
void reconos_app_cleanup() {
		mbox_destroy(resources_inittcpipserver);
		mbox_destroy(resources_initfeatureextractionmanagersw);
		mbox_destroy(resources_initfeatureextractionmanagerhw);
		mbox_destroy(resources_initfeatureprojection);
		mbox_destroy(resources_initlda);
		mbox_destroy(resources_initclassification);
		mbox_destroy(resources_samplewindowsw);
		mbox_destroy(resources_samplewindowhw);
		mbox_destroy(resources_featurewindow);
		mbox_destroy(resources_mavmav);
		mbox_destroy(resources_projectedfeatures);
		mbox_destroy(resources_acknowledgementclassification);
		mbox_destroy(resources_ldatrainingdataset);
		mbox_destroy(resources_ldaprojectionmatrix);
		mbox_destroy(resources_ldaclassmeans);
	

	

	

	
}

/*
 * Empty software thread if no software specified
 *
 *   data - pointer to ReconOS thread
 */
void *swt_idle(void *data) {
	pthread_exit(0);
}


struct reconos_resource *resources_tcp_ip_server[] = {&resources_inittcpipserver_res,&resources_initfeatureextractionmanagersw_res,&resources_initfeatureextractionmanagerhw_res,&resources_initfeatureprojection_res,&resources_initlda_res,&resources_initclassification_res,&resources_samplewindowsw_res,&resources_samplewindowhw_res,&resources_featurewindow_res,&resources_mavmav_res,&resources_projectedfeatures_res,&resources_acknowledgementclassification_res,&resources_ldatrainingdataset_res,&resources_ldaprojectionmatrix_res,&resources_ldaclassmeans_res};

/*
 * @see header
 */
struct reconos_thread *reconos_thread_create_hwt_tcp_ip_server() {
	struct reconos_thread *rt = (struct reconos_thread *)malloc(sizeof(struct reconos_thread));
	if (!rt) {
		panic("[reconos-core] ERROR: failed to allocate memory for thread\n");
	}

	int slots[] = {};
	reconos_thread_init(rt, "tcp_ip_server", 0);
	reconos_thread_setinitdata(rt, 0);
	reconos_thread_setallowedslots(rt, slots, 0);
	reconos_thread_setresourcepointers(rt, resources_tcp_ip_server, 15);
	reconos_thread_create_auto(rt, RECONOS_THREAD_HW);

	return rt;
}

extern void *rt_tcp_ip_server(void *data);

/*
 * @see header
 */
struct reconos_thread *reconos_thread_create_swt_tcp_ip_server() {
	struct reconos_thread *rt = (struct reconos_thread *)malloc(sizeof(struct reconos_thread));
	if (!rt) {
		panic("[reconos-core] ERROR: failed to allocate memory for thread\n");
	}

	int slots[] = {};
	reconos_thread_init(rt, "tcp_ip_server", 0);
	reconos_thread_setinitdata(rt, 0);
	reconos_thread_setallowedslots(rt, slots, 0);
	reconos_thread_setresourcepointers(rt, resources_tcp_ip_server, 15);
	reconos_thread_setswentry(rt, rt_tcp_ip_server);
	reconos_thread_create_auto(rt, RECONOS_THREAD_SW);

	return rt;
}


/*
 * @see header
 */
void reconos_thread_destroy_tcp_ip_server(struct reconos_thread *rt) {
	// not implemented yet
}


struct reconos_resource *resources_feature_extraction_manager[] = {&resources_inittcpipserver_res,&resources_initfeatureextractionmanagersw_res,&resources_initfeatureextractionmanagerhw_res,&resources_initfeatureprojection_res,&resources_initlda_res,&resources_initclassification_res,&resources_samplewindowsw_res,&resources_samplewindowhw_res,&resources_featurewindow_res,&resources_mavmav_res,&resources_projectedfeatures_res,&resources_acknowledgementclassification_res,&resources_ldatrainingdataset_res,&resources_ldaprojectionmatrix_res,&resources_ldaclassmeans_res};

/*
 * @see header
 */
struct reconos_thread *reconos_thread_create_hwt_feature_extraction_manager() {
	struct reconos_thread *rt = (struct reconos_thread *)malloc(sizeof(struct reconos_thread));
	if (!rt) {
		panic("[reconos-core] ERROR: failed to allocate memory for thread\n");
	}

	int slots[] = {0};
	reconos_thread_init(rt, "feature_extraction_manager", 0);
	reconos_thread_setinitdata(rt, 0);
	reconos_thread_setallowedslots(rt, slots, 1);
	reconos_thread_setresourcepointers(rt, resources_feature_extraction_manager, 15);
	reconos_thread_create_auto(rt, RECONOS_THREAD_HW);

	return rt;
}

extern void *rt_feature_extraction_manager(void *data);

/*
 * @see header
 */
struct reconos_thread *reconos_thread_create_swt_feature_extraction_manager() {
	struct reconos_thread *rt = (struct reconos_thread *)malloc(sizeof(struct reconos_thread));
	if (!rt) {
		panic("[reconos-core] ERROR: failed to allocate memory for thread\n");
	}

	int slots[] = {0};
	reconos_thread_init(rt, "feature_extraction_manager", 0);
	reconos_thread_setinitdata(rt, 0);
	reconos_thread_setallowedslots(rt, slots, 1);
	reconos_thread_setresourcepointers(rt, resources_feature_extraction_manager, 15);
	reconos_thread_setswentry(rt, rt_feature_extraction_manager);
	reconos_thread_create_auto(rt, RECONOS_THREAD_SW);

	return rt;
}


/*
 * @see header
 */
void reconos_thread_destroy_feature_extraction_manager(struct reconos_thread *rt) {
	// not implemented yet
}


struct reconos_resource *resources_feature_projection[] = {&resources_inittcpipserver_res,&resources_initfeatureextractionmanagersw_res,&resources_initfeatureextractionmanagerhw_res,&resources_initfeatureprojection_res,&resources_initlda_res,&resources_initclassification_res,&resources_samplewindowsw_res,&resources_samplewindowhw_res,&resources_featurewindow_res,&resources_mavmav_res,&resources_projectedfeatures_res,&resources_acknowledgementclassification_res,&resources_ldatrainingdataset_res,&resources_ldaprojectionmatrix_res,&resources_ldaclassmeans_res};

/*
 * @see header
 */
struct reconos_thread *reconos_thread_create_hwt_feature_projection() {
	struct reconos_thread *rt = (struct reconos_thread *)malloc(sizeof(struct reconos_thread));
	if (!rt) {
		panic("[reconos-core] ERROR: failed to allocate memory for thread\n");
	}

	int slots[] = {};
	reconos_thread_init(rt, "feature_projection", 0);
	reconos_thread_setinitdata(rt, 0);
	reconos_thread_setallowedslots(rt, slots, 0);
	reconos_thread_setresourcepointers(rt, resources_feature_projection, 15);
	reconos_thread_create_auto(rt, RECONOS_THREAD_HW);

	return rt;
}

extern void *rt_feature_projection(void *data);

/*
 * @see header
 */
struct reconos_thread *reconos_thread_create_swt_feature_projection() {
	struct reconos_thread *rt = (struct reconos_thread *)malloc(sizeof(struct reconos_thread));
	if (!rt) {
		panic("[reconos-core] ERROR: failed to allocate memory for thread\n");
	}

	int slots[] = {};
	reconos_thread_init(rt, "feature_projection", 0);
	reconos_thread_setinitdata(rt, 0);
	reconos_thread_setallowedslots(rt, slots, 0);
	reconos_thread_setresourcepointers(rt, resources_feature_projection, 15);
	reconos_thread_setswentry(rt, rt_feature_projection);
	reconos_thread_create_auto(rt, RECONOS_THREAD_SW);

	return rt;
}


/*
 * @see header
 */
void reconos_thread_destroy_feature_projection(struct reconos_thread *rt) {
	// not implemented yet
}


struct reconos_resource *resources_lda[] = {&resources_inittcpipserver_res,&resources_initfeatureextractionmanagersw_res,&resources_initfeatureextractionmanagerhw_res,&resources_initfeatureprojection_res,&resources_initlda_res,&resources_initclassification_res,&resources_samplewindowsw_res,&resources_samplewindowhw_res,&resources_featurewindow_res,&resources_mavmav_res,&resources_projectedfeatures_res,&resources_acknowledgementclassification_res,&resources_ldatrainingdataset_res,&resources_ldaprojectionmatrix_res,&resources_ldaclassmeans_res};

/*
 * @see header
 */
struct reconos_thread *reconos_thread_create_hwt_lda() {
	struct reconos_thread *rt = (struct reconos_thread *)malloc(sizeof(struct reconos_thread));
	if (!rt) {
		panic("[reconos-core] ERROR: failed to allocate memory for thread\n");
	}

	int slots[] = {};
	reconos_thread_init(rt, "lda", 0);
	reconos_thread_setinitdata(rt, 0);
	reconos_thread_setallowedslots(rt, slots, 0);
	reconos_thread_setresourcepointers(rt, resources_lda, 15);
	reconos_thread_create_auto(rt, RECONOS_THREAD_HW);

	return rt;
}

extern void *rt_lda(void *data);

/*
 * @see header
 */
struct reconos_thread *reconos_thread_create_swt_lda() {
	struct reconos_thread *rt = (struct reconos_thread *)malloc(sizeof(struct reconos_thread));
	if (!rt) {
		panic("[reconos-core] ERROR: failed to allocate memory for thread\n");
	}

	int slots[] = {};
	reconos_thread_init(rt, "lda", 0);
	reconos_thread_setinitdata(rt, 0);
	reconos_thread_setallowedslots(rt, slots, 0);
	reconos_thread_setresourcepointers(rt, resources_lda, 15);
	reconos_thread_setswentry(rt, rt_lda);
	reconos_thread_create_auto(rt, RECONOS_THREAD_SW);

	return rt;
}


/*
 * @see header
 */
void reconos_thread_destroy_lda(struct reconos_thread *rt) {
	// not implemented yet
}


struct reconos_resource *resources_classification[] = {&resources_inittcpipserver_res,&resources_initfeatureextractionmanagersw_res,&resources_initfeatureextractionmanagerhw_res,&resources_initfeatureprojection_res,&resources_initlda_res,&resources_initclassification_res,&resources_samplewindowsw_res,&resources_samplewindowhw_res,&resources_featurewindow_res,&resources_mavmav_res,&resources_projectedfeatures_res,&resources_acknowledgementclassification_res,&resources_ldatrainingdataset_res,&resources_ldaprojectionmatrix_res,&resources_ldaclassmeans_res};

/*
 * @see header
 */
struct reconos_thread *reconos_thread_create_hwt_classification() {
	struct reconos_thread *rt = (struct reconos_thread *)malloc(sizeof(struct reconos_thread));
	if (!rt) {
		panic("[reconos-core] ERROR: failed to allocate memory for thread\n");
	}

	int slots[] = {};
	reconos_thread_init(rt, "classification", 0);
	reconos_thread_setinitdata(rt, 0);
	reconos_thread_setallowedslots(rt, slots, 0);
	reconos_thread_setresourcepointers(rt, resources_classification, 15);
	reconos_thread_create_auto(rt, RECONOS_THREAD_HW);

	return rt;
}

extern void *rt_classification(void *data);

/*
 * @see header
 */
struct reconos_thread *reconos_thread_create_swt_classification() {
	struct reconos_thread *rt = (struct reconos_thread *)malloc(sizeof(struct reconos_thread));
	if (!rt) {
		panic("[reconos-core] ERROR: failed to allocate memory for thread\n");
	}

	int slots[] = {};
	reconos_thread_init(rt, "classification", 0);
	reconos_thread_setinitdata(rt, 0);
	reconos_thread_setallowedslots(rt, slots, 0);
	reconos_thread_setresourcepointers(rt, resources_classification, 15);
	reconos_thread_setswentry(rt, rt_classification);
	reconos_thread_create_auto(rt, RECONOS_THREAD_SW);

	return rt;
}


/*
 * @see header
 */
void reconos_thread_destroy_classification(struct reconos_thread *rt) {
	// not implemented yet
}

