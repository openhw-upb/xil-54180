/*
 *                                                        ____  _____
 *                            ________  _________  ____  / __ \/ ___/
 *                           / ___/ _ \/ ___/ __ \/ __ \/ / / /\__ \
 *                          / /  /  __/ /__/ /_/ / / / / /_/ /___/ /
 *                         /_/   \___/\___/\____/_/ /_/\____//____/
 *
 * ======================================================================
 *
 *   title:        Thread library header file
 *
 *   project:      ReconOS
 *   author:       Andreas Agne, University of Paderborn
 *                 Christoph Rüthing, University of Paderborn
 *   description:  Auto-generated thread specific header file including
 *                 resource definitions and helper macros.
 *
 * ======================================================================
 */



#ifndef RECONOS_THREAD_H
#define RECONOS_THREAD_H

#include "reconos_app.h"

/* == Thread resources ================================================= */

/*
 * Definition of resource ids local to this thread. Always use the pointers
 * directory and not resource array indexed by these ids.
 */
#define RESOURCES_INITTCPIPSERVER 0x00000000
#define RESOURCES_INITFEATUREEXTRACTIONMANAGERSW 0x00000001
#define RESOURCES_INITFEATUREEXTRACTIONMANAGERHW 0x00000002
#define RESOURCES_INITFEATUREPROJECTION 0x00000003
#define RESOURCES_INITLDA 0x00000004
#define RESOURCES_INITCLASSIFICATION 0x00000005
#define RESOURCES_SAMPLEWINDOWSW 0x00000006
#define RESOURCES_SAMPLEWINDOWHW 0x00000007
#define RESOURCES_FEATUREWINDOW 0x00000008
#define RESOURCES_MAVMAV 0x00000009
#define RESOURCES_PROJECTEDFEATURES 0x0000000a
#define RESOURCES_ACKNOWLEDGEMENTCLASSIFICATION 0x0000000b
#define RESOURCES_LDATRAININGDATASET 0x0000000c
#define RESOURCES_LDAPROJECTIONMATRIX 0x0000000d
#define RESOURCES_LDACLASSMEANS 0x0000000e


/* == Thread helper macros ============================================= */

/*
 * Definition of the entry function to the ReconOS thread. Every ReconOS
 * thread should be defined using this macro:
 *
 *   THREAD_ENTRY() {
 *     // thread code here
 *   }
 }
 */
#define THREAD_ENTRY()\
	void rt_lda(void *data)

#endif /* RECONOS_THREAD_H */