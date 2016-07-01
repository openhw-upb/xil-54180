

CC = $(CROSS_COMPILE)g++
CFLAGS += -O3 -Wall -I ../../../../ReconOS/reconos -I lib/include -D RECONOS_OS_linux -D RECONOS_BOARD_zedboard_d -O3
LDFLAGS += -static -lpthread

MKDIRP = mkdir -p

OBJS = rt_feature_extraction_manager/rt_feature_extraction_manager.o rt_feature_projection/rt_feature_projection.o rt_classification/rt_classification.o lib/runtime/reconos.o lib/runtime/reconos_app.o lib/runtime/comp/rqueue.o lib/runtime/comp/mbox.o lib/runtime/arch/arch_linux.o lib/runtime/arch/arch_xilkernel.o lib/runtime/pglib/sample_window.o lib/runtime/pglib/lda_regression.o lib/runtime/pglib/classification_r.o lib/runtime/pglib/dataset.o lib/runtime/pglib/projection_matrix_r.o lib/runtime/pglib/numerics.o lib/runtime/pglib/logtime.o lib/runtime/pglib/timediff.o lib/runtime/pglib/feature_projection_r.o lib/runtime/pglib/feature_extraction.o application/main.o rt_lda/rt_lda.o rt_tcp_ip_server/rt_tcp_ip_server.o 
BUILD_OBJS = $(OBJS:%=_build/%)

all: $(BUILD_OBJS)
	$(CC) $(BUILD_OBJS) $(LDFLAGS) -o lda

install: all
	cp lda $(PREFIX)

clean:
	rm -rf _build lda

_build/%.o: %.c
	$(MKDIRP) $(@D)
	$(CC) $(CFLAGS) -x c -c $< -o $@

_build/%.o: %.cpp
	$(MKDIRP) $(@D)
	$(CC) $(CFLAGS) -x c++ -c $< -o $@
