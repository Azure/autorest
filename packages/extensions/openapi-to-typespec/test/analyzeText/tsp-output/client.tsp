import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";


using Azure.ClientGenerator.Core;
using Azure.Language.Authoring;









@@clientLocation(TextAnalysisAuthoringOperationGroup.listProjects, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.createProject, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getProject, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.deleteProject, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.export, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.import, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.train, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.listDeployments, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.swapDeployments, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getDeployment, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.deployProject, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.deleteDeployment, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getDeploymentStatus, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getSwapDeploymentsStatus, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getExportStatus, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getImportStatus, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.listTrainedModels, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getTrainedModel, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.deleteTrainedModel, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getModelEvaluationResults, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getModelEvaluationSummary, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.listTrainingJobs, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getTrainingStatus, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.cancelTrainingJob, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getProjectDeletionStatus, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.getSupportedLanguages, "TextAnalysisAuthoring")
@@clientLocation(TextAnalysisAuthoringOperationGroup.listTrainingConfigVersions, "TextAnalysisAuthoring")


