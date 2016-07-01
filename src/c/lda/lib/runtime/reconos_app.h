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



#ifndef RECONOS_APP_H
#define RECONOS_APP_H

#include "mbox.h"

#include <pthread.h>
#include <semaphore.h>

/* == Application resources ============================================ */

/*
 * Definition of different resources of the application.
 *
 *   mbox  - mailbox (struct mbox)
 *   sem   - semaphore (sem_t)
 *   mutex - mutex (pthread_mutex)
 *   cond  - condition variable (pthread_cond)
 */
extern struct mbox resources_inittcpipserver_s;
extern struct mbox *resources_inittcpipserver;

extern struct mbox resources_initfeatureextractionmanagersw_s;
extern struct mbox *resources_initfeatureextractionmanagersw;

extern struct mbox resources_initfeatureextractionmanagerhw_s;
extern struct mbox *resources_initfeatureextractionmanagerhw;

extern struct mbox resources_initfeatureprojection_s;
extern struct mbox *resources_initfeatureprojection;

extern struct mbox resources_initlda_s;
extern struct mbox *resources_initlda;

extern struct mbox resources_initclassification_s;
extern struct mbox *resources_initclassification;

extern struct mbox resources_samplewindowsw_s;
extern struct mbox *resources_samplewindowsw;

extern struct mbox resources_samplewindowhw_s;
extern struct mbox *resources_samplewindowhw;

extern struct mbox resources_featurewindow_s;
extern struct mbox *resources_featurewindow;

extern struct mbox resources_mavmav_s;
extern struct mbox *resources_mavmav;

extern struct mbox resources_projectedfeatures_s;
extern struct mbox *resources_projectedfeatures;

extern struct mbox resources_acknowledgementclassification_s;
extern struct mbox *resources_acknowledgementclassification;

extern struct mbox resources_ldatrainingdataset_s;
extern struct mbox *resources_ldatrainingdataset;

extern struct mbox resources_ldaprojectionmatrix_s;
extern struct mbox *resources_ldaprojectionmatrix;

extern struct mbox resources_ldaclassmeans_s;
extern struct mbox *resources_ldaclassmeans;










/* == Application functions ============================================ */

/*
 * Initializes the application by creating all resources.
 */
void reconos_app_init();

/*
 * Cleans up the application by destroying all resources.
 */
void reconos_app_cleanup();

/*
 * Creates a hardware thread in the specified slot with its associated
 * resources.
 *
 *   rt   - pointer to the ReconOS thread
 */
struct reconos_thread *reconos_thread_create_hwt_tcp_ip_server();

/*
 * Creates a software thread with its associated resources.
 *
 *   rt   - pointer to the ReconOS thread
 */
struct reconos_thread *reconos_thread_create_swt_tcp_ip_server();


/*
 * Destroyes a hardware thread created.
 *
 *   rt   - pointer to the ReconOS thread
 */
void reconos_thread_destroy_tcp_ip_server(struct reconos_thread *rt);

/*
 * Creates a hardware thread in the specified slot with its associated
 * resources.
 *
 *   rt   - pointer to the ReconOS thread
 */
struct reconos_thread *reconos_thread_create_hwt_feature_extraction_manager();

/*
 * Creates a software thread with its associated resources.
 *
 *   rt   - pointer to the ReconOS thread
 */
struct reconos_thread *reconos_thread_create_swt_feature_extraction_manager();


/*
 * Destroyes a hardware thread created.
 *
 *   rt   - pointer to the ReconOS thread
 */
void reconos_thread_destroy_feature_extraction_manager(struct reconos_thread *rt);

/*
 * Creates a hardware thread in the specified slot with its associated
 * resources.
 *
 *   rt   - pointer to the ReconOS thread
 */
struct reconos_thread *reconos_thread_create_hwt_feature_projection();

/*
 * Creates a software thread with its associated resources.
 *
 *   rt   - pointer to the ReconOS thread
 */
struct reconos_thread *reconos_thread_create_swt_feature_projection();


/*
 * Destroyes a hardware thread created.
 *
 *   rt   - pointer to the ReconOS thread
 */
void reconos_thread_destroy_feature_projection(struct reconos_thread *rt);

/*
 * Creates a hardware thread in the specified slot with its associated
 * resources.
 *
 *   rt   - pointer to the ReconOS thread
 */
struct reconos_thread *reconos_thread_create_hwt_lda();

/*
 * Creates a software thread with its associated resources.
 *
 *   rt   - pointer to the ReconOS thread
 */
struct reconos_thread *reconos_thread_create_swt_lda();


/*
 * Destroyes a hardware thread created.
 *
 *   rt   - pointer to the ReconOS thread
 */
void reconos_thread_destroy_lda(struct reconos_thread *rt);

/*
 * Creates a hardware thread in the specified slot with its associated
 * resources.
 *
 *   rt   - pointer to the ReconOS thread
 */
struct reconos_thread *reconos_thread_create_hwt_classification();

/*
 * Creates a software thread with its associated resources.
 *
 *   rt   - pointer to the ReconOS thread
 */
struct reconos_thread *reconos_thread_create_swt_classification();


/*
 * Destroyes a hardware thread created.
 *
 *   rt   - pointer to the ReconOS thread
 */
void reconos_thread_destroy_classification(struct reconos_thread *rt);



#endif /* RECONOS_APP_H */